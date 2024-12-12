//
//  SelectedPublisherTitlesVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/1/24.
//

import UIKit

class SelectedPublisherTitlesVC: CODataLoadingVC
{
    enum Section { case main }
    
    var selectedPublisherName: String!
    var selectedPublisherDetailsURL: String!
    var titles                  = [Title]()
    var filteredTitles          = [Title]()
    var savedTitles             = [Title]()
    var isSearching             = false
    var tableView: UITableView!
    var dataSource: UITableViewDiffableDataSource<Section,Title>!
    
    init(underPublisher publisherName: String, withDetailsURL publisherDetailsURL: String)
    {
        super.init(nibName: nil, bundle: nil)
        self.selectedPublisherName = publisherName
        self.selectedPublisherDetailsURL = publisherDetailsURL
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureNavigationVC()
        configureSearchController()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        configureTableView()
        getSavedTitles()
        getPublisherTitles()
        configureDataSource()
    }
    
    
    func configureNavigationVC()
    {
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName   = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        
        view.backgroundColor        = .systemBackground
        title                       = "\(selectedPublisherName!) Titles"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    
    func configureSearchController()
    {
        let mySearchController                                  = UISearchController()
        mySearchController.searchResultsUpdater                 = self
        mySearchController.searchBar.delegate                   = self
        mySearchController.searchBar.placeholder                = "Search for a title"
        mySearchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController                         = mySearchController
        navigationItem.hidesSearchBarWhenScrolling              = false
    }
    
    
    func hideSearchController() { navigationItem.searchController?.searchBar.isHidden = true }
    
    
    func configureTableView()
    {
        tableView = UITableView(frame: view.bounds)
        
        view.addSubview(tableView)
        tableView.delegate          = self
        tableView.backgroundColor   = .systemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    
    func configureDataSource()
    {
        dataSource = UITableViewDiffableDataSource<Section,Title>(tableView: tableView, cellProvider: { (tableView, indexPath, title) -> UITableViewCell? in
            let cell                = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text    = title.name
            cell.accessoryType      = self.savedTitles.contains(title) ? .checkmark : .none
            
            return cell
        })
    }
    
    
    func updateUI(with titles: [Title])
    {
        self.titles.append(contentsOf: titles)
        
        // self.titles = []
        if self.titles.isEmpty {
            let message = EmptyStateKeys.noTitlesPublished
            DispatchQueue.main.async {
                self.hideSearchController()
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.titles)
    }
    
    
    func updateData(on titles: [Title])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Title>()
        snapshot.appendSections([.main])
        #warning("below .appendItems fails/app crashing when I enter this VC, click a title and navigate back. cell accessory not the reason")
        snapshot.appendItems(titles)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    func getSavedTitles()
    {
        PersistenceManager.loadBookmarx { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedTitles):
                self.savedTitles = savedTitles
                
            case .failure(let error):
                self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func getPublisherTitles()
    {
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
extension SelectedPublisherTitlesVC: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let activeArray                     = isSearching ? filteredTitles : titles
        let title                           = activeArray[indexPath.row]
        let destVC                          = SelectedTitleIssuesVC(forTitle: title)
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}


// MARK: SEARCHBAR DELEGATE METHODS

extension SelectedPublisherTitlesVC: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let filter    = searchController.searchBar.text, !filter.isEmpty else { return }
        
        isSearching         = true
        filteredTitles      = titles.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredTitles)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        isSearching = false
        updateData(on: titles)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == "" {
            isSearching = false
            updateData(on: titles)
        }
    }
}
