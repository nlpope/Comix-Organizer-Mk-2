//
//  FilteredPublishersVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 7/5/24.
//

import UIKit

protocol FilteredPublishersVCDelegate: AnyObject {
    func didRequestTitles(fromPublisher publisher: String, withPublisherDetailsURL detailsURL: String)
}

class FilteredPublishersVC: CODataLoadingVC {
    
    enum Section { case main }
    
    var publisherContainsName: String!
    var publishers              = [Publisher]()
    var filteredPublishers      = [Publisher]()
    var page                    = 0
    var hasMorePublishers       = true
    var isSearching             = false
    var isLoadingMorePublishers = false
    static var isFirstVisit     = true
    
    // see note 5 in app delegate
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Publisher>!
    weak var delegate: FilteredPublishersVCDelegate!
    
    
    init(withName name: String) {
        super.init(nibName: nil, bundle: nil)
        self.publisherContainsName = name
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureSearchController()
        configureCollectionView()
        getFilteredPublishers()
        configureDataSource()
        presentListOrderAlert()
        // see note 10 in app delegate
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    // see note 15 in app delegate
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        FilteredPublishersVC.isFirstVisit = false
    }
    
    
    func presentListOrderAlert() {
        guard FilteredPublishersVC.isFirstVisit else { return }
        presentCOAlertOnMainThread(alertTitle: "Important", message: "The following list is loaded by popularity THEN alphabetically. So 'Z' may appear just before 'A' at the bottom when new publishers load. Happy searching 😁.", buttonTitle: "ok")
    }
    
    
    private func configureNavigationController() {
        view.backgroundColor    = .systemBackground
        title                   = "Publishers"
        
        navigationController?.navigationBar.prefersLargeTitles      = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    
    
    func configureSearchController() {
        let mySearchController                                  = UISearchController()
        mySearchController.searchResultsUpdater                 = self
        mySearchController.searchBar.delegate                   = self
        mySearchController.searchBar.placeholder                = "Search for a publisher"
        mySearchController.obscuresBackgroundDuringPresentation = false
        
        navigationItem.searchController                         = mySearchController
        navigationItem.hidesSearchBarWhenScrolling              = false
    }
    
    
    func hideSearchController() {
        navigationItem.searchController?.searchBar.isHidden = true
    }
    
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
        
        view.addSubview(collectionView)
        collectionView.delegate         = self
        collectionView.backgroundColor  = .systemBackground
        collectionView.register(PublisherCell.self, forCellWithReuseIdentifier: PublisherCell.reuseID)
    }
    
    
    // see note 12b in app delegate
    func getFilteredPublishers() {
        showLoadingView()
        isLoadingMorePublishers = true
        Task {
            do {
                let results = try await APICaller.shared.getFilteredPublishers(withName: publisherContainsName, page: page)
                dismissLoadingView()
                updateUI(with: results)
                self.isLoadingMorePublishers = false
            } catch is COError {
                showEmptyStateView(with: COError.invalidURL.rawValue, in: self.view)
                print(COError.invalidURL.rawValue)
            }
        }
    }
    
    
    func updateUI(with publishers: [Publisher]) {
        if publishers.count < 100 { self.hasMorePublishers = false }
        self.publishers.append(contentsOf: publishers)
        
        // test empty state
        // self.publishers = []
        if self.publishers.isEmpty {
            let message = "There are no publishers by the name \(publisherContainsName!) to display 😢."
            DispatchQueue.main.async {
                self.hideSearchController()
                self.showEmptyStateView(with: message, in: self.view)
            }
            return
        }
        self.updateData(on: self.publishers)
    }
    
    
    func updateData(on publishers: [Publisher]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Publisher>()
        snapshot.appendSections([.main])
        snapshot.appendItems(publishers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Publisher>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, publisher) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublisherCell.reuseID, for: indexPath) as! PublisherCell
            cell.set(publisher: publisher)
            
            return cell
        })
    }
}


//MARK: COLLECTIONVIEW DELEGATE METHODS
extension FilteredPublishersVC: UICollectionViewDelegate {
    
    // see note 13 in app delegate
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePublishers, !isLoadingMorePublishers else { return }
            page += 100
            getFilteredPublishers()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredPublishers : publishers
        let publisher       = activeArray[indexPath.item]
        
        delegate?.didRequestTitles(fromPublisher: publisher.name, withPublisherDetailsURL: publisher.publisherDetailsURL)
    }
}


// MARK: SEARCHBAR DELEGATE METHODS
extension FilteredPublishersVC: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let filter = searchController.searchBar.text, !filter.isEmpty else { return }
        
        isSearching         = true
        filteredPublishers  = publishers.filter { $0.name.lowercased().contains(filter.lowercased()) }
        updateData(on: filteredPublishers)
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        updateData(on: publishers)
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            isSearching = false
            updateData(on: publishers)
        }
    }
}
