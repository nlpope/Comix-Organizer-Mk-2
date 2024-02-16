//
//  PublisherTitlesViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/6/24.
//

import UIKit
import CoreData

//Titles = Volumes in API
class SelectedPublisherTitlesViewController: UIViewController {
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    private var selectedPublisherTitles = [Volume]()
    
    
    private var publisherTitles = [Volume]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewWillAppear(_ animated: Bool) {
        Task {
            await configurePublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL)
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        title = "\(selectedPublisherName)"

        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: CONFIGURATION
    func configurePublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async {
        if let results = try? await APICaller.shared.getPublisherTitlesAPI(withPublisherDetailsURL: selectedPublisherDetailsURL) {
            self.selectedPublisherTitles += results
        }
    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension SelectedPublisherTitlesViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedPublisherTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = selectedPublisherTitles[indexPath.row].volumeName
        
        return cell
    }
    
    //MARK: DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("it works")
    }

}
