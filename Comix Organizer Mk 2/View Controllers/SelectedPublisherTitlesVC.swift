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
    
    // see note _ in app delegate > page, isLoadingMoreTitles, & hasMoreTitles doesn't apply since the API dumps all 13k or so items out at once
    var titles                  = [Title]()
    var filteredTitles          = [Title]()
    var isSearching             = false
    
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, Title>!
        
//    let tableView: UITableView = {
//        let table = UITableView()
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return table
//    }()
    
    
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
        configureNavigationVC()
        configureSearchController()
        configureTableView()
        // can i configure datasource just after the tableview here?
        #warning("the load screen is either leaving too early or the table view doesnt appear until you start scrolling - solve this, tableview should appear as soon as load anim. leaves")
        getPublisherTitles()
        configureDataSource()
        
//        Task {
//            showLoadingView()
//             
//            await configurePublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL)
//            view.addSubview(tableView)
//            tableView.delegate = self
//            tableView.dataSource = self
//            tableView.frame = view.bounds
//            
//            dismissLoadingView()
//        }
    }
    
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.frame = view.bounds
//    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureNavigationVC() {
        view.backgroundColor = .systemBackground
        
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        title = "\(selectedPublisherName!) Titles"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    func configureSearchController() {
        let mySearchController                                  = UISearchController()
        mySearchController.searchResultsUpdater                 = self
        mySearchController.searchBar.delegate                   = self
        mySearchController.searchBar.placeholder                = "Search for a title"
        mySearchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController                         = mySearchController
        navigationItem.hidesSearchBarWhenScrolling              = false
    }
    
    
    func hideSearchController() {
        navigationItem.searchController?.searchBar.isHidden = true
    }
    
    
    func configureTableView() {
        #warning("if table dissapears, uncomment viewDidLayoutSubviews method")
        tableView = UITableView(frame: view.bounds)
        
        view.addSubview(tableView)
        tableView.delegate          = self
        tableView.backgroundColor   = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func configureDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Title>(tableView: tableView, cellProvider: { (tableView, indexPath, title) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = title.titleName
            
            return cell
        })
    }
    
    
    func updateUI(with titles: [Title]) {
        self.titles.append(contentsOf: titles)
        
        // test empty state
        // self.titles = []
        if self.titles.isEmpty {
            let message = "There doesn't seem to be any titles under this publisher 😢."
            DispatchQueue.main.async {
                self.hideSearchController()
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.titles)
    }
    
    
    func updateData(on titles: [Title]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Title>()
        snapshot.appendSections([.main])
        snapshot.appendItems(titles)
        DispatchQueue.main.async {self.dataSource.apply(snapshot, animatingDifferences: true)}
        
    }
    
    
    func getPublisherTitles() {
        showLoadingView()
        Task {
            do {
                let results = try await APICaller.shared.getPublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL)
                dismissLoadingView()
                updateUI(with: results)
            } catch is COError {
                showEmptyStateView(with: COError.invalidURL.rawValue, in: self.view)
                print(COError.invalidURL.rawValue)
            }
        }
    }
    
    
//    func configurePublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async {
//        if let results = try? await APICaller.shared.getPublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL) {
//            
//            self.titles += results
//            self.titles = self.titles.filter{$0.titleName != ""}
//            
//        } else {
//            print("something went wrong in configurePublisherTitles")
//        }
//    }
    
}


//MARK: TABLEVIEW DELEGATE METHODS
#warning("consider removing delegate & protocols since setup is happening via inits & navcontroller pushing - it'd be different if for inst. a modal was dictating what is happening on the screen behind it - add this to app del. notes")
extension SelectedPublisherTitlesVC: UITableViewDelegate, AllPublishersVCDelegate, FilteredPublishersVCDelegate {
    
    func didRequestTitles(fromPublisher publisher: String, withPublisherDetailsURL detailsURL: String) {
        self.selectedPublisherName = publisher
        self.selectedPublisherDetailsURL = detailsURL
    }
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // sift through array of selectedpublishertitles
//        // if any of them equal "", decrease the count (-= 1)
//        return titles.count
//    }
    
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text = titles[indexPath.row].titleName
//       
//        // remove duplicate named cells here? (compare btwn curr. & last string)
//        
//        return cell
//    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selctedTitleIssuesVC = SelectedTitleIssuesVC()
        
        selctedTitleIssuesVC.selectedTitleName = titles[indexPath.row].titleName
        selctedTitleIssuesVC.selectedTitleDetailsURL = titles[indexPath.row].titleDetailsURL
        print("IssuesVC selectedTitleDetailsURL = \(selctedTitleIssuesVC.selectedTitleDetailsURL)")
        self.navigationController?.pushViewController(selctedTitleIssuesVC, animated: true)
    }
}


// MARK: SEARCHBAR DELEGATE METHODS
extension SelectedPublisherTitlesVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        isSearching         = true
        filteredTitles      = titles.filter { $0.titleName.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredTitles)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: titles)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            updateData(on: titles)
        }
    }
}
