//
//  ComicBoxViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import UIKit

class ComixBinVC: CODataLoadingVC {
    
    var tableView: UITableView!
    var savedTitles = [Title]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationController()
        configureTableView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // see note 18 in app delegate
        getSavedTitles()
    }
    
    
    func configureNavigationController() {
        view.backgroundColor    = .systemBackground
        title                   = "ComixBin"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    
    func configureTableView() {
        tableView                   = UITableView(frame: view.bounds)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        view.addSubview(tableView)
        tableView.delegate          = self
        tableView.dataSource        = self
        tableView.tableFooterView   = UIView(frame:  .zero)
    }
    
    
    func getSavedTitles() {
        PersistenceManager.retrieveBookmarx { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let savedTitles):
                updateUI(with: savedTitles)
                
            case .failure(let error):
                self.presentCOAlertOnMainThread(alertTitle: "Something went wrong", message: error.rawValue, buttonTitle: "Ok")
            }
        }
    }
    
    
    func updateUI(with savedTitles: [Title]) {
        if savedTitles.isEmpty {
            self.showEmptyStateView(with: "No saved titles?\nHit the '+' on your favorite titles to start keeping track here.", in: self.view)
        } else {
            self.savedTitles = savedTitles
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
}


extension ComixBinVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let savedTitle = savedTitles[indexPath.row]
        cell.textLabel?.text = savedTitle.titleName
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title               = savedTitles[indexPath.row]
        let destVC              = SelectedTitleIssuesVC(selectedTitleName: title.titleName, selectedTitleDetailsURL: title.titleDetailsURL)
        destVC.titleID          = title.titleID
        destVC.titleInQuestion  = title
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
