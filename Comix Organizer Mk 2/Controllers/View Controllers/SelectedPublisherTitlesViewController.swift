//
//  SelectedPublisherTitlesViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/6/24.
//

import UIKit
import CoreData

//Titles = Volumes in API
//remove delegate pattern for the load once the dot issue is sorted
//03.15: just removed LoadAnimationDelegate pattern & conformance below
class SelectedPublisherTitlesViewController: UIViewController {
    public var selectedPublisherName = ""
    public var selectedPublisherDetailsURL = ""
    public var publisherHasNoTitles = false
    private var selectedPublisherTitles = [Title]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if selectedPublisherName.contains("Comics") {
            selectedPublisherName = selectedPublisherName.replacingOccurrences(of: "Comics", with: "Comix")
        }
        title = "\(selectedPublisherName) Titles/Volumes"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        Task {
            //why is animation switching to vertical here?
            //answer down below in notes & notebook
            presentLoadingAnimationViewController()
            
            await configurePublisherTitles(withPublisherDetailsURL: selectedPublisherDetailsURL)
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            
            dismissLoadingAnimationViewController()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    //MARK: CONFIGURATION
    func configurePublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async {
        
        if let results = try? await APICaller.shared.getPublisherTitlesAPI(withPublisherDetailsURL: selectedPublisherDetailsURL) {
            
            self.selectedPublisherTitles += results
            self.selectedPublisherTitles = self.selectedPublisherTitles.filter{$0.titleName != ""}
            //delete this contingency?
//            if publisherHasNoTitles {
//                self.navigationController?.pushViewController(AllPublishersViewController(), animated: true)
//                //trigger single button pop-up
//                var popUpWindowSBVC: PopUpWindowSingleButtonViewController!
//                popUpWindowSBVC = PopUpWindowSingleButtonViewController(title: "No titles available", text: "We're sorry, but the selected publisher holds no titles. We will work to have this item removed. Thank you.", buttonOneText: "Ok")
//                self.present(popUpWindowSBVC, animated: true, completion: nil)
//
//            } else {
//                
//                self.selectedPublisherTitles += results
//            }
        } else {
            print("something went wrong in configurePublisherTitles")
        }
    }
    
//    func setPublisherZeroTitleCountProp() {
//        publisherHasNoTitles = publisherHasNoTitles == true ? false : true
//
//        print("\(publisherHasNoTitles.description)")
//    }
    
    func presentLoadingAnimationViewController() {
        //03.15: sumn's wrong in here
        //what if i removed the delegate pattern entirely?
        //.. that worked for like a second then it didnt
        let loadingAnimationVC = LoadAnimationViewController()
        
        //hide the navigation controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        //03.15: just set the animation to "true"
        self.navigationController?.pushViewController(loadingAnimationVC, animated: true)
    }
    
    func dismissLoadingAnimationViewController() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK: DELEGATE & DATASOURCE METHODS
extension SelectedPublisherTitlesViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //sift through array of selectedpublishertitles
        //if any of them equal "", decrease the count (-= 1)
        return selectedPublisherTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = selectedPublisherTitles[indexPath.row].titleName
       
        //remove duplicate named cells here? (compare btwn curr. & last string)
        
        return cell
    }
    
    //MARK: DELEGATE
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selctedTitleIssuesVC = SelectedTitleIssuesViewController()
        
        selctedTitleIssuesVC.selectedTitleName = selectedPublisherTitles[indexPath.row].titleName
        selctedTitleIssuesVC.selectedTitleDetailsURL = selectedPublisherTitles[indexPath.row].titleDetailsURL
        print("IssuesVC selectedTitleDetailsURL = \(selctedTitleIssuesVC.selectedTitleDetailsURL)")
        self.navigationController?.pushViewController(selctedTitleIssuesVC, animated: true)
    }
}
