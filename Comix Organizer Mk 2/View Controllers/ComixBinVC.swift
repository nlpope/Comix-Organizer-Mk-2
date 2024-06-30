//
//  ComicBoxViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 2/3/24.
//

import Foundation
import UIKit

class ComixBinVC: UIViewController {
    private var volumeCollection = [Title]()
    private var issueCollection = [Issue]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        //load collection from context
        //and divide volume & issue collections via slider
        //like stopwatch in clock app
    }
}
