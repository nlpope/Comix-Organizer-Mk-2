//
//  SelectedTitleIssuesVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

#warning("model this after SelectedPublisherTitlesVC - only NO DIFF. DATASOURCE, LEAVE TABLEVIEW AS IS")
class SelectedTitleIssuesVC: CODataLoadingVC {

    var selectedTitleName: String!
    var selectedTitleDetailsURL: String!
    var selectedTitleIssues = [Issue]()
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
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
        
        Task {
            showLoadingView()
            
            await configureTitleIssues()
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            
            dismissLoadingView()
        }
    }
    
    
    func configureNavigationController() {
        title = "\(selectedTitleName!)"
        view.backgroundColor = .systemBackground
        navigationItem.title = "\(selectedTitleName!) Issues"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    //why isn't this an override func here, like it is in selectedPublisherTitles/CharactersVC?
    func viewDidLayoutSubViews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: CONFIGURATION
    //withTitleDetailsURL selectedTitleDetailsURL: String
    //i took out the params here for it being redundant; params only needed for API call & the val for THAT param exists up  top (preset by last VC)
    func configureTitleIssues() async {
            if let results = try? await APICaller.shared.getTitleIssues(withTitleDetailsURL: selectedTitleDetailsURL) {
            //if no issues boot out and send a popup saying there are no issues in this title/volume
            
            self.selectedTitleIssues += results
                self.selectedTitleIssues = self.selectedTitleIssues.filter{$0.issueName != ""}
                //publisher = avon; title = betty boop
           
        } else {
            print("something went wrong in configureTitleIssues().")
        }
        
    }
}



//MARK: DELEGATE & DATASOURCE METHODS
extension SelectedTitleIssuesVC: UITableViewDelegate, UITableViewDataSource {
    
    func didRequestIssues(forTitle: String) {
        // do stuff
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTitleIssues.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let theIssue = selectedTitleIssues[indexPath.row]
        cell.textLabel?.text = theIssue.issueName
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("it works")
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell!.accessoryType == .none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        //see: https://stackoverflow.com/questions/8388136/how-to-remove-the-check-mark-on-another-click
        
        
    }
}

