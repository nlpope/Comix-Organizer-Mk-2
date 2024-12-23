////
////  AllPublishersVC.swift
////  Comix Organizer Mk 2
////
////  Created by Noah Pope on 11/7/23.
////
//
//import UIKit
//
//class AllPublishersVC: CODataLoadingVC
//{
//    enum Section { case main }
//    
//    var publishers              = [Publisher]()
//    var filteredPublishers      = [Publisher]()
//    var page                    = 0
//    var hasMorePublishers       = true
//    var isSearching             = false
//    var isLoadingMorePublishers = false
//    static var isFirstVisit     = true
//    var collectionView: UICollectionView!
//    var dataSource: UICollectionViewDiffableDataSource<Section,Publisher>!
//    
//    override func viewDidLoad()
//    {
//        super.viewDidLoad()
//        configureNavigationController()
//        configureSearchController()
//        configureCollectionView()
//        getPublishers(page: page)
//        configureDataSource()
//        presentListOrderAlert()
//    }
//    
//    
//    override func viewWillAppear(_ animated: Bool)
//    {
//        super.viewWillAppear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: true)
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool)
//    {
//        super.viewDidAppear(animated)
//        AllPublishersVC.isFirstVisit = false
//    }
//    
//    
//    func presentListOrderAlert()
//    {
//        guard AllPublishersVC.isFirstVisit else { return }
//        presentCOAlertOnMainThread(alertTitle: "Important", message: "The following list is loaded by popularity THEN alphabetically. So 'Z' may appear just before 'A' at the bottom when new publishers load. Happy searching 😁.", buttonTitle: "ok")
//    }
//    
//    
//    private func configureNavigationController()
//    {
//        view.backgroundColor    = .systemBackground
//        title                   = "Publishers"
//        
//        navigationController?.navigationBar.prefersLargeTitles      = true
//        navigationController?.navigationItem.largeTitleDisplayMode  = .always
//    }
//    
//    
//    func configureSearchController()
//    {
//        let mySearchController                                  = UISearchController()
//        mySearchController.searchResultsUpdater                 = self
//        mySearchController.searchBar.delegate                   = self
//        mySearchController.searchBar.placeholder                = "Search for a publisher"
//        mySearchController.obscuresBackgroundDuringPresentation = false
//        
//        navigationItem.searchController                         = mySearchController
//        navigationItem.hidesSearchBarWhenScrolling              = false
//    }
//    
//    
//    func hideSearchController() { navigationItem.searchController?.searchBar.isHidden = true }
//    
//    
//    func configureCollectionView()
//    {
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
//        
//        view.addSubview(collectionView)
//        collectionView.delegate         = self
//        collectionView.backgroundColor  = .systemBackground
//        collectionView.register(COCell.self, forCellWithReuseIdentifier: COCell.reuseID)
//    }
//    
//    
//    func getPublishers(page: Int)
//    {
//        showLoadingView()
//        isLoadingMorePublishers = true
//        Task {
//            do {
//                let results = try await APICaller.shared.getAllPublishers(page: page)
//                dismissLoadingView()
//                updateUI(with: results)
//                self.isLoadingMorePublishers = false
//            } catch is COError {
//                showEmptyStateView(with: COError.invalidURL.rawValue, in: self.view)
//                print(COError.invalidURL.rawValue)
//            }
//        }
//    }
//    
//    
//    func updateUI(with publishers: [Publisher])
//    {
//        if publishers.count < 100 { self.hasMorePublishers = false }
//        self.publishers.append(contentsOf: publishers)
//        
//        // test empty state
//        // self.publishers = []
//        if self.publishers.isEmpty {
//            let message = "There are no more publishers to display 😢."
//            DispatchQueue.main.async {
//                self.hideSearchController()
//                self.showEmptyStateView(with: message, in: self.view)
//            }
//            return
//        }
//        self.updateData(on: self.publishers)
//    }
//    
//    
//    func updateData(on publishers: [Publisher])
//    {
//        var snapshot = NSDiffableDataSourceSnapshot<Section,Publisher>()
//        snapshot.appendSections([.main])
//        snapshot.appendItems(publishers)
//        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
//    }
//    
//    
//    func configureDataSource()
//    {
//        dataSource      = UICollectionViewDiffableDataSource<Section,Publisher>(collectionView: collectionView,
//                                                                                 cellProvider: { (collectionView, indexPath, publisher) -> UICollectionViewCell? in
//            let cell    = collectionView.dequeueReusableCell(withReuseIdentifier: COCell.reuseID, for: indexPath) as! COCell
//            cell.set(resourceBundle: publisher)
//            
//            return cell
//        })
//    }
//}
//
//
////MARK: COLLECTIONVIEW DELEGATE METHODS
//extension AllPublishersVC: UICollectionViewDelegate
//{
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
//    {
//        let offsetY         = scrollView.contentOffset.y
//        let contentHeight   = scrollView.contentSize.height
//        let height          = scrollView.frame.size.height
//        
//        if offsetY > contentHeight - height {
//            guard hasMorePublishers, !isLoadingMorePublishers else { return }
//            page += 100
//            getPublishers(page: page)
//        }
//    }
//    
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
//    {
//        let activeArray     = isSearching ? filteredPublishers : publishers
//        let publisher       = activeArray[indexPath.item]
//        let destVC          = SelectedPublisherTitlesVC(underPublisher: publisher.name, withDetailsURL: publisher.publisherDetailsURL)
//        
//        navigationController?.pushViewController(destVC, animated: true)
//    }
//}
//
//
//// MARK: SEARCHBAR DELEGATE METHODS
//
//extension AllPublishersVC: UISearchResultsUpdating, UISearchBarDelegate
//{
//    func updateSearchResults(for searchController: UISearchController)
//    {
//        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
//        
//        isSearching         = true
//        filteredPublishers  = publishers.filter { $0.name.lowercased().contains(filter.lowercased()) }
//        updateData(on: filteredPublishers)
//    }
//    
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
//    {
//        isSearching = false
//        updateData(on: publishers)
//    }
//    
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
//    {
//        if searchText == "" {
//            isSearching = false
//            updateData(on: publishers)
//        }
//    }
//}
