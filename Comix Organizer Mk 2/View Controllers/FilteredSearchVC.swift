//
//  FilteredSearchVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/5/24.
//

import UIKit

class FilteredSearchVC: CODataLoadingVC
{
    enum Section { case main }
    
    var queryContains: String!
    var publishers              = [ResourceBundle]()
    var filteredPublishers      = [ResourceBundle]()
    var page                    = 0
    var hasMorePublishers       = true
    var isSearching             = false
    var isLoadingMorePublishers = false
    static var isFirstVisit     = true
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,ResourceBundle>!
    
    init(withName name: String)
    {
        super.init(nibName: nil, bundle: nil)
        self.queryContains = name
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureNavigationController()
        configureSearchController()
        configureCollectionView()
        getFilteredPublishers()
        configureDataSource()
        presentListOrderAlert()
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        FilteredSearchVC.isFirstVisit = false
    }
    
    
    func presentListOrderAlert()
    {
        guard FilteredSearchVC.isFirstVisit else { return }
        presentCOAlertOnMainThread(alertTitle: "Important", message: "The following list is loaded by popularity THEN alphabetically. So 'Z' may appear just before 'A' at the bottom when new publishers load. Happy searching 😁.", buttonTitle: "ok")
    }
    
    
    private func configureNavigationController()
    {
        view.backgroundColor    = .systemBackground
        title                   = "Results For: '\(queryContains!)'"
        
        navigationController?.navigationBar.prefersLargeTitles      = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(switchToCharacterView))
    }
    
    
    @objc func switchToCharacterView()
    {
        
    }
    
    
    func configureSearchController()
    {
        let mySearchController                                  = UISearchController()
        mySearchController.searchResultsUpdater                 = self
        mySearchController.searchBar.delegate                   = self
        mySearchController.searchBar.placeholder                = "Search for a publisher"
        mySearchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController                         = mySearchController
        navigationItem.hidesSearchBarWhenScrolling              = false
    }
    
    
    func hideSearchController() { navigationItem.searchController?.searchBar.isHidden = true }
    
    
    func configureCollectionView()
    {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.delegate         = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.register(COCell.self, forCellWithReuseIdentifier: COCell.reuseID)
    }
    
    
    func configureDataSource()
    {
        dataSource = UICollectionViewDiffableDataSource<Section,ResourceBundle>(
            collectionView: collectionView,
            cellProvider: { (collectionView, indexPath, resourceBundle) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: COCell.reuseID, for: indexPath) as! COCell
            cell.set(resourceBundle: resourceBundle)
            
            return cell
        })
    }
    
    
    func getFilteredPublishers()
    {
        showLoadingView()
        isLoadingMorePublishers = true
        Task {
            do
            {
                let results                     = try await APICaller.shared.getAllResults(forQuery: queryContains, page: 0)
                dismissLoadingView()
                updateUI(with: results)
                self.isLoadingMorePublishers    = false
            }
            catch is COError { showEmptyStateView(with: COError.invalidURL.rawValue, in: self.view) }
        }
    }
    
    
    func updateUI(with resources: [ResourceBundle])
    {
        if resources.count < 100 { self.hasMorePublishers = false }
        self.publishers.append(contentsOf: resources)
        
        // self.publishers = []
        if self.publishers.isEmpty {
            let message = "There are no publishers by the name \(queryContains!) to display 😢."
            DispatchQueue.main.async {
                self.hideSearchController()
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.publishers)
    }
    
    
    func updateData(on resources: [ResourceBundle])
    {
        var snapshot = NSDiffableDataSourceSnapshot<Section,ResourceBundle>()
        snapshot.appendSections([.main])
        snapshot.appendItems(resources)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}


//MARK: COLLECTIONVIEW DELEGATE METHODS
extension FilteredSearchVC: UICollectionViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePublishers, !isLoadingMorePublishers else { return }
            page += 100
            getFilteredPublishers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
//        let activeArray     = isSearching ? filteredPublishers : publishers
//        let publisher       = activeArray[indexPath.item]
//        let destVC          = SelectedPublisherTitlesVC(underPublisher: publisher.name, withDetailsURL: publisher.publisherDetailsURL)
//        
//        navigationController?.pushViewController(destVC, animated: true)
        print("working")
    }
}


// MARK: SEARCHBAR DELEGATE METHODS

extension FilteredSearchVC: UISearchResultsUpdating, UISearchBarDelegate
{
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        isSearching         = true
        filteredPublishers  = publishers.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredPublishers)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
    {
        isSearching = false
        updateData(on: publishers)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == "" {
            isSearching = false
            updateData(on: publishers)
        }
    }
}
