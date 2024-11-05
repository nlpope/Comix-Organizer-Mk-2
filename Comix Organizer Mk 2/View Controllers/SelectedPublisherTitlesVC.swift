//
//  SelectedPublisherTitlesVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class SelectedPublisherTitlesVC: CODataLoadingVC {

    enum Section { case main }
    
    var selectedPublisherName: String!
    var selectedPublisherDetailsURL: String!
    
    // see note 16 in app delegate
    var titles                  = [Title]()
    var filteredTitles          = [Title]()
    var isSearching             = false
    
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section, Title>!
    
    
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
        getPublisherTitles()
        configureDataSource()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func configureNavigationVC() {
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName   = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        
        view.backgroundColor        = .systemBackground
        title                       = "\(selectedPublisherName!) Titles"
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
            cell.accessoryType
            
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
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
        
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
}


//MARK: TABLEVIEW DELEGATE METHODS
extension SelectedPublisherTitlesVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let activeArray                     = isSearching ? filteredTitles : titles
        let title                           = activeArray[indexPath.row]
        let destVC                          = SelectedTitleIssuesVC(selectedTitleName: title.titleName, selectedTitleDetailsURL: title.titleDetailsURL)
        destVC.titleID                      = title.titleID
        destVC.titleInQuestion              = title
        
        self.navigationController?.pushViewController(destVC, animated: true)
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
