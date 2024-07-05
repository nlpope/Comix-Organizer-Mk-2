//
//  AllPublishersVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit

protocol AllPublishersVCDelegate: CODataLoadingVC {
    func didRequestTitles(fromPublisher publisher: String, withPublisherDetailsURL detailsURL: String)
}

class AllPublishersVC: CODataLoadingVC {
    
    enum Section { case main }
    
    var publishers              = [Publisher]()
    var filteredPublishers      = [Publisher]()
    var page                    = 0
    var hasMorePublishers       = true
    var isSearching             = false
    var isLoadingMorePublishers = false
    
    // see note 5 in app delegate
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Publisher>!
    weak var delegate: AllPublishersVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureSearchController()
        configureCollectionView()
        getPublishers(page: page)
        configureDataSource()
        // see note 10 in app delegate
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
    func getPublishers(page: Int) {
        showLoadingView()
        Task {
            do {
                let results = try await APICaller.shared.getPublishers(page: page)
                dismissLoadingView()
                updateUI(with: results)
                self.isLoadingMorePublishers = false
            } catch is COError {
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
            let message = "There are no more publishers to display 😢."
            DispatchQueue.main.async {
                self.hideSearchController()
                
                self.showEmptyStateView(with: message, in: self.view)
            }
            
            return
        }
        
        self.updateData(on: self.publishers)
    }
    
    
    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Publisher>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, publisher) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PublisherCell.reuseID, for: indexPath) as! PublisherCell
            cell.set(publisher: publisher)
            
            return cell
        })
    }
    
    
    func updateData(on publishers: [Publisher]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Publisher>()
        snapshot.appendSections([.main])
        snapshot.appendItems(publishers)
        DispatchQueue.main.async { self.dataSource.apply(snapshot, animatingDifferences: true) }
    }
}


//MARK: COLLECTIONVIEW DELEGATE METHODS
extension AllPublishersVC: UICollectionViewDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY         = scrollView.contentOffset.y
        let contentHeight   = scrollView.contentSize.height
        let height          = scrollView.frame.size.height
        
        if offsetY > contentHeight - height {
            guard hasMorePublishers, !isLoadingMorePublishers else { return }
            page += 1
            getPublishers(page: page)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let activeArray     = isSearching ? filteredPublishers : publishers
        let publisher       = activeArray[indexPath.item]
        
        delegate?.didRequestTitles(fromPublisher: publisher.name, withPublisherDetailsURL: publisher.publisherDetailsURL)
    }
}


// MARK: SEARCHBAR DELEGATE METHODS
extension AllPublishersVC: UISearchResultsUpdating, UISearchBarDelegate {
    
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
            searchBar.resignFirstResponder()
            isSearching = false
            updateData(on: publishers)
        }
    }
}


// see note 4 in app delegate


//extension AllPublishersVC: UITableViewDataSource, UITableViewDelegate {
//    
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return publishers.count }
//    
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell                = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
//        cell.textLabel?.text    = publishers[indexPath.row].name
//        
//        return cell
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        // now call delegate?.didRequestTitles(fromPublisher..) in the didSelect method for the collection view delegate in here when you say selectedPublisherTitlesVC = SelectedPublisherTitlesVC( )
//       
//        
//        // trigger pop-up
//        var popUpWindowVC: PopUpWindowChildVC!
//        popUpWindowVC           = PopUpWindowChildVC(title: "Please Specify", text: "What would you like to see from this publisher?", buttonOneText: "Titles", buttonTwoText: "Characters", selectedPublisherName: selectedPublisherName, selectedPublisherDetailsURL: selectedPublisherDetailsURL)
//        
//        popUpWindowVC.delegate = self
//        self.present(popUpWindowVC, animated: true, completion: nil)
//    }
//    
//    
//    func presentTitlesViewController() {
//        
//    }
//}
