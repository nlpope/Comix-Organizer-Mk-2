//
//  AllPublishersVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit

protocol AllPublishersVCDelegate: AnyObject {
    func didRequestTitles(fromPublisher publisher: String)
}

class AllPublishersVC: UIViewController {
    
    enum Section { case main }
    
    private var publishers = [Publisher]()
    
    //see note 5 in app delegate
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Publisher>!
    // now call delegate?.didRequestTitles(fromPublisher..) in the didSelect method for the collection view delegate in here when you say selectedPublisherTitlesVC = SelectedPublisherTitlesVC( )
    weak var delegate: AllPublishersVCDelegate!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        Task { try await getPublishers() }
        // see note _ in app delegate > calling configureTableView() here results in blank page
    }
    
    #warning("is this lifecycle method necessary or can i move the contents to VDL?")
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    private func configureNavigationController() {
        view.backgroundColor    = .systemBackground
        title                   = "Publishers"
        
        navigationController?.navigationBar.prefersLargeTitles      = true
        navigationController?.navigationItem.largeTitleDisplayMode  = .always
    }
    
    
    func getPublishers() async throws {
        presentLoadAnimationVC()
        #warning("change to guard let?")
        if let results = try? await APICaller.shared.getPublishers() { self.publishers += results } else {
            self.dismissLoadAnimationVC()
            throw COError.failedToGetData
        }
        configureTableView()
        dismissLoadAnimationVC()
    }
    
    
    func configureTableView() {
        print("inside configureTableView")
        view.addSubview(tableView)
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.frame         = view.bounds
    }
}


//MARK: DELEGATE & DATASOURCE METHODS
extension AllPublishersVC: UITableViewDataSource, UITableViewDelegate, PopUpWindowChildVCDelegate, SelectedPublisherTitlesVCDelegate {
    
    func didRequestTitles(fromPublisher publisher: String) {
        <#code#>
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return publishers.count }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell                = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text    = publishers[indexPath.row].name
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPublisherName       = publishers[indexPath.row].name
        selectedPublisherDetailsURL = publishers[indexPath.row].publisherDetailsURL
        
        // trigger pop-up
        var popUpWindowVC: PopUpWindowChildVC!
        popUpWindowVC           = PopUpWindowChildVC(title: "Please Specify", text: "What would you like to see from this publisher?", buttonOneText: "Titles", buttonTwoText: "Characters", selectedPublisherName: selectedPublisherName, selectedPublisherDetailsURL: selectedPublisherDetailsURL)
        
        popUpWindowVC.delegate = self
        self.present(popUpWindowVC, animated: true, completion: nil)
    }
    
    
    func presentTitlesViewController() {
        
    }
}

// see note 4 in app delegate




