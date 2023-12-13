//
//  AllPublishersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit
import CoreData

//this is the HomeViewController / HomeVC
//dont forget to add logic for when publisher cant be found/pulled

class AllPublishersViewController: UIViewController {
    
    private var publishers: [Publisher] = [Publisher]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    //CORE DATA STEP 2
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let group = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        title = "Publishers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        
        Task {
            await configurePublishers()
            print("viewdidload pub array after config:\n \(self.publishers)")
        }
    }
    
    private func configurePublishers() async {
        print("inside configurePublishers()")
        
        if let results = try? await APICaller.shared.getPublishers() {
            self.publishers += results
            print("publishers arr after config call: \(self.publishers)")
        } else {
            print("sumn' went wrong")
        }
        
    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension AllPublishersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "dummy thicc"
        //        cell.textLabel?.text = publishers[indexPath.row].name
        return cell
    }
    
    
}

/**
 --------------------------
 SHORTCUTS:
 * edit this boilerplate using: cmd + shift + L
 * storyboard object lisit: cmd + shift + L
 
 * hide/reveal debug area = cmd + shift + Y
 * hide/reveal console = cmd + shift + C
 * hide/reveal left pane = cmd + 0
 * hide/reveal right pane = cmd + shift + 0
 * hide/reveal preview window = cmd + shift + enter
 
 --------------------------
 GETTING STARTED:
 * remove storyboard to code interface programmatically
 > https://medium.com/@yatimistark/removing-storyboard-from-app-xcode-14-swift-5-2c707deb858
 
 * App Icons & LaunchScreens:
 
 > icon
 1. delete app icon present in assests folder
 2. bake icon
 3. drag generated icon directly to assets folder
 
 > launchscreen
 1. bake icon
 2. drag generated icon to finder (ton of options should appear)
 3. drag "appstore1024.png"  image under app icon
 4. name it "LaunchScreen"
 5. add a new "LaunchScreen" file
 6. set an image inside
 7. attributes inspector - set image to "LaunchScreen" from assets
 
 * Delegate & Datasource Methods
 * Delegate & Datasource Methods
 > list of mandatory methods
 > https://stackoverflow.com/questions/5831813/delegate-and-datasource-methods-for-uitableview
 
 > The datasource supplies the data,
 > the delegate supplies the behavior
 > https://stackoverflow.com/questions/2232147/whats-the-difference-between-data-source-and-delegate
 
 
 * Network & API Calls
 > default = async await
 > be wary of AlamoFire, it does not support async await (see senpai link below)
 .
 > why is async await (structured concurrency) preferred over new swift 5.5 completion handlers?
 >> note: most probs below are contributed to new "Result" enum
 >> avoids deep nesting (pyramid of doom) that completion handlers are prone to
 >> more readable
 >> "Switch"ing through the results & weak references no longer needed
 >> transition from sync to asyncy context is clearer
 >> opens up world of Swift Actors (helps avoid data races & concurrency problems)
 .
 > helpful links + how ot convert:
 >> https://swiftsenpai.com/swift/async-await-network-requests/ (start here)
 >> https://developer.apple.com/forums/thread/712303
 >> https://www.avanderlee.com/swift/async-await/
 1. just set up the APICaller using the "async throws" method (first link above)
 2. ... then, when calling it in the VC, mark the func alling the async method as "async" as well
 3. up in the ViewDidLoad, wrap the final reference in a Task {...} so things get hashed out in order
 3. ... this task should contain a "try? await" statement wrapped in a results var where the "shared" func is finally called
 --------------------------
 PROJECT NOTES:
 
 11.20.23
 * creating postman account to pull metron data over
 > https://www.youtube.com/watch?v=VywxIQ2ZXw4
 >> @ 5.37
 
 11.21.23
 * Learning postman to sync w Metron & pull publishers
 
 11.22.23
 * downloading postman app & reviewing postman/metron docs
 > do I need Mokkari?
 
 11.24.23
 * swift docs auth process link
 > https://developer.apple.com/documentation/foundation/url_loading_system/handling_an_authentication_challenge#2942074
 * S.O. auth process link
 >  https://stackoverflow.com/questions/24379601/how-to-make-an-http-request-basic-auth-in-swift
 
 11.28.23
 * reading docs on url authentication challenges
 * holding off on mokarri download for now til i figure out the above
 
 11.30.23
 * swithing to comic vine API in place of metron
 > metron = mokarri + postman + http auth challenge
 > comic vine = api key
 
 * comic vine api basic walkthrough (country hat guy)
 > https://josephephillips.com/blog/how-to-use-comic-vine-api-part1
 
 12.07.23
 * seeing if planting call in async solves the "not being filled outside of closure" problem
 > read below two before contin.
 >> https://stackoverflow.com/questions/70962534/swift-await-async-how-to-wait-synchronously-for-an-async-task-to-complete
 >> https://stackoverflow.com/questions/48713427/how-to-make-async-await-in-swift
 
 12.08.23
 * DispatchGroup() not working as expected
 > tinkering w async / await next
 >> https://medium.com/@gianlucaannina_34907/api-calls-using-swift-async-await-and-error-handling-c8efcb000e63
 
 12.11.23
 * researching async vs escaping closures - may need to switch to async?
 > Sidharth Juyal article
 >> https://medium.com/@chunkyguy/swift-async-await-vs-closures-6d9b1b86cba5#:~:text=Swift%20await%20works%20by%20capturing%20the%20context%20and%20suspending%20the,as%20equivalent%20to%20escaping%20closure.
 > swift docs (async funcs)
 >> https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
 
 12.12.23
 * switching to async
 > helpful links:
 >> https://swiftsenpai.com/swift/async-await-network-requests/ (start here)
 >> https://developer.apple.com/forums/thread/712303
 >> https://www.avanderlee.com/swift/async-await/
 
 --------------------------
 HARD KNOCKS:
 
 * simulators disappeared?
 > restart computer
 > https://developer.apple.com/forums/thread/120250
 
 --------------------------
 */





