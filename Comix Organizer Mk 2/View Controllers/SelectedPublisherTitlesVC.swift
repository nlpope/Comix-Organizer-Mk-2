//
//  SelectedPublisherTitlesVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit
import CoreData

#warning("keep this a tableview for lack of access to indiv. title imgs but set up searchable diff. datasource")

protocol SelectedPublisherTitlesVCDelegate: AnyObject {
    func didRequestIssues(forTitle: String)
}

class SelectedPublisherTitlesVC: CODataLoadingVC {

    enum Section { case main }
    
    var selectedPublisherName: String!
    var selectedPublisherDetailsURL: String!
    
    var selectedPublisherTitles = [Title]()
    var page                    = 0
    var hasMoreTitles           = true
    var isSearching             = false
    var isLoadingMoreTitles     = false
    
    var dataSource: UITableViewDiffableDataSource<Section, Title>!
    
//    weak var delegate: SelectedPublisherTitlesVCDelegate!
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    
    init(underPublisher publisherName: String, withDetailsURL publisherDetailsURL: String) {
        super.init(nibName: nil, bundle: nil)
        self.selectedPublisherName = publisherName
        self.selectedPublisherDetailsURL = publisherDetailsURL
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        title = "\(selectedPublisherName!) Titles"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        Task {
            //why is animation switching to vertical here?
            //answer down below in notes & notebook
            showLoadingView()
             
            await configurePublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL)
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            
            dismissLoadingView()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    //MARK: CONFIGURATION
    func configurePublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async {
        if let results = try? await APICaller.shared.getPublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL) {
            
            self.selectedPublisherTitles += results
            self.selectedPublisherTitles = self.selectedPublisherTitles.filter{$0.titleName != ""}
            
        } else {
            print("something went wrong in configurePublisherTitles")
        }
    }
}


//MARK: DELEGATE & DATASOURCE METHODS
#warning("consider removing delegate & protocols since setup is happening via inits & navcontroller pushing - it'd be different if for inst. a modal was dictating what is happening on the screen behind it - add this to app del. notes")
extension SelectedPublisherTitlesVC: UITableViewDelegate, UITableViewDataSource, AllPublishersVCDelegate, FilteredPublishersVCDelegate {
    
    func didRequestTitles(fromPublisher publisher: String, withPublisherDetailsURL detailsURL: String) {
        self.selectedPublisherName = publisher
        self.selectedPublisherDetailsURL = detailsURL
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // sift through array of selectedpublishertitles
        // if any of them equal "", decrease the count (-= 1)
        return selectedPublisherTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = selectedPublisherTitles[indexPath.row].titleName
       
        // remove duplicate named cells here? (compare btwn curr. & last string)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        #warning("create alt '...VC' version of below then test run")
        let selctedTitleIssuesVC = SelectedTitleIssuesVC()
        
        selctedTitleIssuesVC.selectedTitleName = selectedPublisherTitles[indexPath.row].titleName
        selctedTitleIssuesVC.selectedTitleDetailsURL = selectedPublisherTitles[indexPath.row].titleDetailsURL
        print("IssuesVC selectedTitleDetailsURL = \(selctedTitleIssuesVC.selectedTitleDetailsURL)")
        self.navigationController?.pushViewController(selctedTitleIssuesVC, animated: true)
    }
}
