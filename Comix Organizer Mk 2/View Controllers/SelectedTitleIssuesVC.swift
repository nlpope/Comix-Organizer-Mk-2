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
    
    var titleID: Int!
    var selectedTitleIssues  = [Issue]()
    var persistedTitleIssues = [Issue]()
    
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
        getTitleIssues()
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        loadProgress()
//    }
    
    
    func configureNavigationController() {
        title = "\(selectedTitleName!)"
        view.backgroundColor = .systemBackground
        navigationItem.title = "\(selectedTitleName!) Issues"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        
        navigationItem.rightBarButtonItem = addButton

    }
    
    
    func configureTableView() {
        tableView                   = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        tableView.delegate          = self
        tableView.dataSource        = self
    }
    
    
    func saveProgress() {
        showLoadingView()
        do {
            let activeArray         = persistedTitleIssues.isEmpty ? selectedTitleIssues : persistedTitleIssues

            try PersistenceManager.save(issues: activeArray)
            dismissLoadingView()
            presentCOAlertOnMainThread(alertTitle: "Success!", message: "Your progress has been saved successfully 🥳", buttonTitle: "Yay")
        } catch let error {
            presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: COError.failedToRecordCompletion.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func loadProgress() {
        showLoadingView()
        do {
            let persistedIssues = try PersistenceManager.loadProgress()
            dismissLoadingView()
        } catch {
            presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: COError.failedToLoadProgress.rawValue, buttonTitle: "Ok")
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
}



// MARK: DELEGATE & DATASOURCE METHODS
extension SelectedTitleIssuesVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let activeArray         = persistedTitleIssues.isEmpty ? selectedTitleIssues : persistedTitleIssues
        return activeArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activeArray         = persistedTitleIssues.isEmpty ? selectedTitleIssues : persistedTitleIssues
        let cell                = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let issue               = activeArray[indexPath.row]
        
        cell.textLabel?.text    = "\(issue.issueNumber). \(issue.issueName)"
        
        
        cell.accessoryType      = issue.isFinished ? .checkmark : .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // make var that flicks to false if it's 1st check
        // after 1st check load all data from persistence manager then handle checks down here w the new activeArray
        tableView.deselectRow(at: indexPath, animated: true)
        let activeArray         = persistedTitleIssues.isEmpty ? selectedTitleIssues : persistedTitleIssues

        var issue   = activeArray[indexPath.row]
        let cell    = tableView.cellForRow(at: indexPath)
        
        if cell!.accessoryType == .none {
            cell?.accessoryType = .checkmark
            issue.isFinished    = true
//            saveProgress()
            
        } else {
            cell?.accessoryType = .none
            issue.isFinished    = false
//            saveProgress()
        }
        
        // see: https://stackoverflow.com/questions/8388136/how-to-remove-the-check-mark-on-another-click
        
        
    }
}

