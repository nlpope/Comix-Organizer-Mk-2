//
//  SelectedTitleIssuesViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 3/15/24.
//

import Foundation
import UIKit
import CoreData

//THIS IS THE LAST VC, JUST CELLS CHECKABLE & SET UP CONTEXT
class SelectedTitleIssuesViewController: UIViewController {
    
    public var selectedTitleName = ""
    public var selectedTitleDetailsURL = ""
    private var selectedTitleIssues = [Issue]()
    
    let tableView: UITableView = {
       let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "\(selectedTitleName)"
        navigationItem.title = "\(selectedTitleName) Issues"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        Task {
            presentLoadingAnimationViewController()
            
            await configureTitleIssues()
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            
            dismissLoadingAnimationViewController()
            
            
        }
    }
    
    //why isn't this an override func here, like it is in selectedPublisherTitles/CharactersVC?
    func viewDidLayoutSubViews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: CONFIGURATION
    //withTitleDetailsURL selectedTitleDetailsURL: String
    //i took out the params here for it being redundant; params only needed for API call & the val for THAT param exists up top (preset by last VC)
    func configureTitleIssues() async {
        
        if let results = try? await APICaller.shared.getTitleIssuesAPI(withTitleDetailsURL: selectedTitleDetailsURL) {
            
            self.selectedTitleIssues += results
           
        } else {
            print("something went wrong in configureTitleIssues().")
        }
        
    }
    
    func presentLoadingAnimationViewController() {
        let loadingAnimationVC = LoadAnimationViewController()
        //03.15: commented out - loadingAnimationVC.delegate = self
        
        //hide the navigation controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.pushViewController(loadingAnimationVC, animated: true)
    }
    
    func dismissLoadingAnimationViewController() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension SelectedTitleIssuesViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: DATASOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedTitleIssues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //03.17 - change reuse identifier to a (to be created) "checkableCell" identifier
        //how to programmatically set up a reuse identifier
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let theIssue = selectedTitleIssues[indexPath.row]
        cell.textLabel?.text = theIssue.issueName
        
        return cell
    }
    
    //MARK: DELEGATE METHODS
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //base off of allpubVC didselect method
        print("it works")
    }
}

/**
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 SHORTCUTS:
 * create new code snippets: right click + "create code snippet"
 * edit this code snippet: cmd + shift + L
 * storyboard object lisit: cmd + shift + L
 
 * duplicate a line = cmd + D
 * hide/reveal debug area = cmd + shift + Y
 * hide/reveal console = cmd + shift + C
 * hide/reveal left pane = cmd + 0
 * hide/reveal right pane = cmd + shift + 0
 * hide/reveal preview window = cmd + shift + enter
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 REFERENCE CREDITS
 >
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 PROJECT TRACKING, MILESTONES, & QUESTIONS (DATE STAMP):
 >
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 
 */


