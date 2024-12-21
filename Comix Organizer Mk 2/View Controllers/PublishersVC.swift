//
//  PublishersVC.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/21/24.
//

import UIKit

class PublishersVC: CODataLoadingVC
{
    enum Section { case main }
    
    var queryContains: String!
    var publishers              = [Publisher]()
    var filteredPublishers      = [Publisher]()
    var page                    = 0
    var hasMorePublishers       = true
    var isSearching             = false
    var isLoadingMorePublishers = false
    static var isFirstVisit     = true
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section,Publisher>!
    
    init(withName name: String)
    {
        super.init(nibName: nil, bundle: nil)
        self.queryContains = name
    }
    
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
