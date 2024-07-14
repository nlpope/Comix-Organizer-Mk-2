//
//  SelectedTitleIssuesVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class SelectedTitleIssuesVC: CODataLoadingVC {

    var titleInQuestion: Title!
    var selectedTitleName: String!
    var selectedTitleDetailsURL: String!
    
    // see note 19 in app delegate
    var completedTitleIssues = [Issue]()
    var selectedTitleIssues  = [Issue]()
    var titleID: Int!
    
    var tableView: UITableView!
    
    
    init(selectedTitleName: String, selectedTitleDetailsURL: String) {
        super.init(nibName: nil, bundle: nil)
        self.selectedTitleName = selectedTitleName
        self.selectedTitleDetailsURL = selectedTitleDetailsURL
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        // see note 17 in app delegate
//        loadProgress()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadProgress()
    }
    
    
    func configureNavigationController() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        title = "\(selectedTitleName!)"
        view.backgroundColor                                        = .systemBackground
        navigationItem.title                                        = "\(selectedTitleName!) Issues"
        navigationItem.rightBarButtonItem                           = addButton
        navigationController?.navigationBar.prefersLargeTitles      = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    
    
    func configureTableView() {
        tableView                   = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        tableView.delegate          = self
        tableView.dataSource        = self
    }
    
    
    func loadProgress() {
        PersistenceManager.retrieveCompletedIssues { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let issues):
                self.completedTitleIssues = issues
                print(self.completedTitleIssues)
                getTitleIssues()
                
            case .failure(let error):
                self.presentCOAlertOnMainThread(alertTitle: "Could not retrieve progress", message: error.rawValue, buttonTitle: "Ok")
                getTitleIssues()
            }
        }
    }
    
    
    func getTitleIssues() {
        showLoadingView()
        Task {
            do {
                var results = try await APICaller.shared.getTitleIssues(withTitleDetailsURL: selectedTitleDetailsURL)
                
                results.sort{$0.issueNumber < $1.issueNumber}
                self.selectedTitleIssues += results.filter{$0.issueName != ""}
                dismissLoadingView()
                // see note 17 in app delegate
                configureTableView()
                
            } catch is COError {
                showEmptyStateView(with: COError.failedToGetData.rawValue, in: self.view)
            }
        }
    }
    
    
    @objc func addButtonTapped() { addToComixBin(withTitle: titleInQuestion) }
    
    
    func addToComixBin(withTitle title: Title) {
        showLoadingView()
        PersistenceManager.updateWith(title: title, actionType: .add) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            guard let error = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: "You have successfully saved this title to your ComixBin 🥳.", buttonTitle: "Hooray!")
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func addToCompletedIssues(withIssue issue: Issue) {
        showLoadingView()
        PersistenceManager.updateWith(issue: issue, actionType: .check) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            guard let error = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: "Hope you enjoyed reading this issue. It was saved to your completed list", buttonTitle: "Ok")
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func removeFromCompletedIssues(withIssue issue: Issue) {
        showLoadingView()
        PersistenceManager.updateWith(issue: issue, actionType: .uncheck) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            guard let error = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: "Give this issue another go, later. It was removed from your completed list", buttonTitle: "Ok")
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}



// MARK: DELEGATE & DATASOURCE METHODS
extension SelectedTitleIssuesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTitleIssues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let issue               = selectedTitleIssues[indexPath.row]
        
        cell.textLabel?.text    = "\(issue.issueNumber). \(issue.issueName)"
        cell.accessoryType      = completedTitleIssues.contains(issue) ? .checkmark : .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     
        tableView.deselectRow(at: indexPath, animated: true)

        var issue   = selectedTitleIssues[indexPath.row]
        let cell    = tableView.cellForRow(at: indexPath)
        
        if cell!.accessoryType == .none {
            cell?.accessoryType = .checkmark
            issue.isFinished    = true
            addToCompletedIssues(withIssue: issue)
            
        } else {
            cell?.accessoryType = .none
            issue.isFinished    = false
            removeFromCompletedIssues(withIssue: issue)
        }
        
        // see: https://stackoverflow.com/questions/8388136/how-to-remove-the-check-mark-on-another-click
        
        
    }
}

