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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = .systemBackground
        title = "Publishers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        Task {
            await configurePublishers()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
        }
        
       
    }
    
    //should i re-add "private" to below? benefit?
    func configurePublishers() async {
        if let results = try? await APICaller.shared.getPublishers() {
            self.publishers += results
        } else {
            print("something went wrong in configurePublishers()")
        }
        
    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension AllPublishersViewController: UITableViewDelegate, UITableViewDataSource {
    //datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = publishers[indexPath.row].name
        
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(publishers[indexPath.row].name)")
//        tableView.deselectRow(at: indexPath, animated: true)
        
        let publisher = publishers[indexPath.row].name
        print("didSelect publisher var : \(publisher)")
        let vc = AllCharactersViewController()
        
        Task {
            print("about to configure with: \(publisher)")
            await vc.configureCharacters(with: publisher)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
        
        
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
 HOW TO REMOVE STORYBOARD TO CODE INTERFACE PROGRAMMATICALLY
 
 > https://medium.com/@yatimistark/removing-storyboard-from-app-xcode-14-swift-5-2c707deb858
 
 --------------------------
 APP ICON & LAUNCH SCREEN
 
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
 
 --------------------------
 DELEGATE & DATASOURCE METHODS
 > delegate = what to do when row is clicked (supplies behavior)
 > datasource = book rows & populate (supplies data)
 > despite the order in the naming, the datasource method usually comes first
 >> https://stackoverflow.com/questions/2232147/whats-the-difference-between-data-source-and-delegate
 
 > wrap your "tableView.delegate/datasource = self" in a Task (see below sect.) after your API call
 >> this will ensure there is a "count" in your array to both generate cells & fill them w names
 
 > list of mandatory methods
 > https://stackoverflow.com/questions/5831813/delegate-and-datasource-methods-for-uitableview
  
 --------------------------
 GUARD LET - WHEN YOUR FUNC RETURNS NON-ZERO
 > just set up an enum contianing APIError, then throw it in the else statement:
 
 1. enum APIError: Error {
     case invalidURL
     case failedToGetData
   }
 
  2. guard let url = URL(string: ...) else {
     throw APIError.invalidURL
    }
 
 --------------------------
 * Network & API Calls + Tasks {...}
 > default = async await
 > > be wary of AlamoFire, it does not support async await (see senpai link below)
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
 2. ... then, when calling it in the VC, mark the (configure) func calling the async method as "async" as well
 2a. Also, this configure func is where you will handle your filtering should it be necessary
 3. up in the ViewDidLoad, wrap the final reference in a Task {...} so things get hashed out in order
 3. ... this task should contain a "try? await" statement wrapped in a results var where the "shared" func is finally called
 
 
 --------------------------
 PROJECT NOTES:
 
 API CALL URLs (api key + json formatting + name-field-only for simple testing [to be removed])
 
 publishers url (
 > https://comicvine.gamespot.com/api/publishers/?api_key=b31d5105925e7fd811a07d63e82320578ba699f1&sort=name&format=json&field_list=name,publisher,id,origin,image,deck,birth,api_detail_url,aliases
 characters url (spider-man)
 > https://comicvine.gamespot.com/api/characters/?api_key=b31d5105925e7fd811a07d63e82320578ba699f1&formate=json&filter=name:spider-man&field_list=name,publisher,id,origin,image,deck,birth,api_detail_url,aliases
 
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
 
 12.16
 > there's a split second where the Publishers VC is on display w/out the tables present
 >> they pop in a few seconds later, but how do I make it so the Publishers VC doesn't display til table is populated?
 
 > think i got it - deallocate memory by only loading the cells displayed
 >> maybe it'll load faster under Publishers title
 
 12.18
 > pagination: that's what needs to happen next (lazy loading as you scroll)
 >> next comicvine article should help
 
 > ok, now it's time for:
 >> figuring out call for list of comix under selectedPublisher (view)
 >> pagination
 >> CharacterSelectViewCell setup (configure(with:...) func - see Netflix)
 >> importing character images from comic vine & populating each cell w the OG url @bottom of each call
 
 12.21 ?
 > I want to replace the generic cells in AllCharactersVC w eventual custom characterViewCell
 > 1st line = problem child; 2nd line = necessary reading - read up on URLSesson via docs + all the tangent articles @ the begining
 >>  let results = try JSONDecoder().decode(APICharactersResponse.self, from: data)
 >>  let (data, _) = try await URLSession.shared.data(from: url)
 
 12.23
 > researching server-side encodaable & decodable protocols
 >> https://www.youtube.com/watch?v=yL5Ff5p1hyc
 
 12.24
 > still tweaking Character model
 > you're done, just initialize your props inside decoder's init()
 >> https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types
 >> @ Coordinate structure is extended to conform to the Decodable protocol by implementing its required initializer
 
 ENUMS
 ?? when are enums accessed? automatically when decoding/encoding?
 >>  got it, it's triggered in the init
 let values = try decoder.container(keyedBy: CodingKeys.self)
 >> then, you can go deeper into nest by linking enums:
 
 let publisherNest = try values.nestedContainer(keyedBy: PublisherKeys.self, forKey: .publisher)
 
 //then, reach into that nested container and decode the final vars you want
 publisherID = try publisherNest.decode(Int.self, forKey: .publisherID)
 
 ?? so is it right to be setting up all that decoding logic in the Character model?
 
 > filtering works, but losing publisher contents after await...API...getCharacters() call in AllCharactersVC
 
 12.26
 > researching pagination & comicvine docs for multiple calls
 >> https://comicvine.gamespot.com/forums/api-developers-2334/api-rate-limiting-1746419/

 
 --------------------------
 HARD KNOCKS:
 
 > simulators disappeared?
 >> restart computer
 >>  https://developer.apple.com/forums/thread/120250
 
 --------------------------
 */





