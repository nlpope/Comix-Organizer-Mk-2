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
    var selectedTitleIssues = [Issue]()
    
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
        print("selectedTitleDetailsURL = \(selectedTitleDetailsURL!)")
        configureNavigationController()
        // see note 17 in app delegate
        getTitleIssues()
    }
    
    
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
    
    
//    func getPublisherTitle(withPublisherDetailsURL publisherDetailsURL: String) -> Title {
//        Task {
//            let results = try await APICaller.shared.getPublisherTitles(withPublisherDetailsURL: publisherDetailsURL)
//            let title = results[0]
//            return title
//        }
//    }
    
    
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
        return selectedTitleIssues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let issue = selectedTitleIssues[indexPath.row]
        cell.textLabel?.text = "\(issue.issueNumber). \(issue.issueName)"
        cell.accessoryType = PersistenceManager.loadIssueState(forIssue: issue)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        var issue   = selectedTitleIssues[indexPath.row]
        let cell    = tableView.cellForRow(at: indexPath)
        
        if cell!.accessoryType == .none {
            cell?.accessoryType = .checkmark
            issue.isFinished    = true
            do {
                try PersistenceManager.save(issues: selectedTitleIssues)
            } catch let error {
                presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: , buttonTitle: <#T##String#>)
            }
        } else {
            cell?.accessoryType = .none
            issue.isFinished    = false
        }
        // @ viewWillAppear, persistence.load(cell or load(cells
        // see: https://stackoverflow.com/questions/8388136/how-to-remove-the-check-mark-on-another-click
        
        
    }
}

