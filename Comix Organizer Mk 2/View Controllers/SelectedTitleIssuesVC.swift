//
//  SelectedTitleIssuesVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class SelectedTitleIssuesVC: CODataLoadingVC
{

    var currentTitle: Title!
    var currentTitleIssues      = [Issue]()
    var completedTitleIssues    = [Issue]()
    var titleSavedToBin: Bool!
    var titleID: Int!
    
    var tableView: UITableView!
    
    
    init(forTitle title: Title)
    {
        super.init(nibName: nil, bundle: nil)
        self.currentTitle       = title
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        getSavedTitles()
        configureNavigationController()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        loadProgress()
        getSavedTitles()
    }
    
    
    func getSavedTitles()
    {
        PersistenceManager.loadBookmarx { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedTitles):
                titleSavedToBin = savedTitles.contains(currentTitle) ? true : false
                
            case .failure(let error):
                self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func configureNavigationController()
    {
        let addButton            = UIBarButtonItem(image: SFSymbolKeys.add, style: .plain, target: self, action: #selector(addButtonTapped))
        let subtractButton       = UIBarButtonItem(image: SFSymbolKeys.subtract, style: .plain, target: self, action: #selector(subtractButtonTapped))
        
        title = "\(currentTitle!)"
        view.backgroundColor                                        = .systemBackground
        navigationItem.title                                        = "\(currentTitle.name) Issues"
        navigationItem.rightBarButtonItem                           = titleSavedToBin ? subtractButton : addButton
        navigationController?.navigationBar.prefersLargeTitles      = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    
    
    @objc func addButtonTapped() { addToComixBin(withTitle: currentTitle) }
    
    
    @objc func subtractButtonTapped() { removeFromComixBin(withTitle: currentTitle) }

    
    func loadProgress()
    {
        PersistenceManager.loadCompletedIssues { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let issues):
                self.completedTitleIssues = issues
                getTitleIssues()
                
            case .failure(let error):
                self.presentCOAlertOnMainThread(alertTitle: "Could not retrieve progress", message: error.rawValue, buttonTitle: "Ok")
                getTitleIssues()
            }
        }
    }

    
    func getTitleIssues()
    {
        showLoadingView()
        Task {
            do {
                var results = try await APICaller.shared.getTitleIssues(withTitleDetailsURL: currentTitle.detailsURL)
                
                results.sort{$0.number < $1.number}
                self.currentTitleIssues += results.filter{$0.name != ""}
                dismissLoadingView()
                configureTableView()
            } catch is COError {
                showEmptyStateView(with: COError.failedToGetData.rawValue, in: self.view)
            }
        }
    }
    
    
    func configureTableView()
    {
        tableView                   = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        view.addSubview(tableView)
        tableView.delegate          = self
        tableView.dataSource        = self
    }
    
    
    func addToComixBin(withTitle title: Title)
    {
        showLoadingView()
        PersistenceManager.updateWith(title: title, actionType: .add) { [weak self] error in
            guard let self          = self else { return }
            self.dismissLoadingView()
            self.titleSavedToBin    = true
            guard let error         = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: MessageKeys.titleAdded, buttonTitle: "Hooray!")
                self.configureNavigationController()
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func removeFromComixBin(withTitle title: Title)
    {
        showLoadingView()
        PersistenceManager.updateWith(title: title, actionType: .remove) { [weak self] error in
            guard let self          = self else { return }
            self.dismissLoadingView()
            self.titleSavedToBin    = false
            guard let error         = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: MessageKeys.titleRemoved, buttonTitle: "Ok")
                self.configureNavigationController()
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func markComplete(withIssue issue: Issue)
    {
        showLoadingView()
        PersistenceManager.updateWith(issue: issue, actionType: .check) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            guard let error = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: MessageKeys.issueCompleted, buttonTitle: "Ok")
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
    
    
    func markIncomplete(withIssue issue: Issue)
    {
        showLoadingView()
        PersistenceManager.updateWith(issue: issue, actionType: .uncheck) { [weak self] error in
            guard let self = self else { return }
            self.dismissLoadingView()
            guard let error = error else {
                self.presentCOAlertOnMainThread(alertTitle: "Success!", message: MessageKeys.issueIncomplete, buttonTitle: "Ok")
                return
            }
            
            self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
        }
    }
}


#warning("this file has too many lines")
// MARK: DELEGATE & DATASOURCE METHODS
extension SelectedTitleIssuesVC: UITableViewDelegate, UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return currentTitleIssues.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let issue               = currentTitleIssues[indexPath.row]
        
        cell.textLabel?.text    = "\(issue.number). \(issue.name)"
        cell.accessoryType      = completedTitleIssues.contains(issue) ? .checkmark : .none
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)

        let issue   = currentTitleIssues[indexPath.row]
        let cell    = tableView.cellForRow(at: indexPath)
        
        if cell!.accessoryType == .none {
            cell?.accessoryType = .checkmark
            markComplete(withIssue: issue)
            
        } else {
            cell?.accessoryType = .none
            markIncomplete(withIssue: issue)
        }
    }
}

