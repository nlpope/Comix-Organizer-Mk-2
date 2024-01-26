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
        view.backgroundColor = .systemBackground
        title = "Publishers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
      
        
        Task {
            await configurePublishers()
            //get empty table when below is moved out of Task. why?
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    
    func configurePublishers() async {
        if let results = try? await APICaller.shared.getPublishersAPI() {
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
        cell.textLabel?.text = publishers[indexPath.row].publisherName
        
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedPublisherName = publishers[indexPath.row].publisherName
        let selectedPublisherDetailsURL = publishers[indexPath.row].publisherDetailsURL
        
        self.tabBarController?.selectedIndex = 1
        
        
        
       
        
        
        
        //        self.navigationController?.pushViewController(charactersVC, animated: true)
        
    }
}

//OG DIDSELECT METHOD
//var secondTab = self.tabBarController?.viewControllers?[1] as! AllCharactersViewController
//        let selectedPublisher = publishers[indexPath.row].name
//        let allCharactersVC = AllCharactersViewController()
//        Task {
//            await secondTab.configureCharacters(withPublisher: selectedPublisher)
////            await allCharactersVC.configureCharacters(withPublisher: selectedPublisher)
//            self.navigationController?.tabBarController?.selectedIndex = 1
//        }



/**
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
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
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
 >>  got it, it's triggered in the init(from decoder: Decoder) just below the enums
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
 > ... then making character view cell, complete w image & details  of hero & didSelect delegate that takes you to a (yet uncreated) SelectedCharacterVC.
 ?? how to paginate (comicvine docs above) + create SelectedCharacterVC (1 of many CharacterSelectViewCells will take you there)
 
 12.27
 > scratch pagination, work on infinite scrolling
 >>  https://www.kodeco.com/5786-uitableview-infinite-scrolling-tutorial
 
 12.28
 > researching / considering MVVM approach for the SelectedCharacter portion
 >> https://scottlydon.medium.com/the-differences-between-mvc-and-mvvm-swift-f1936b0bab14
 >> https://stackoverflow.com/questions/667781/what-is-the-difference-between-mvc-and-mvvm/58796188#58796188
 
 >> nvmd, sticking w mvc architecture for simplicity - I'll use mvcvm (mvvm) on a later project
 
 12.29
 > researching UITableViewCell type for CharacterSelectViewCell
 > docs = stopped @ " method of your data source, use your cell’s outlets to assign values to any views" in "configuring the cells for your table"
 
 > reviewing difference btwn UIImageView & UIImage
 >> https://stackoverflow.com/questions/8070805/difference-between-uiimage-and-uiimageview
 
 12.30
 > next up, pull UIImage from url by putting extension from below link in the Character model for now
 >> https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview
 
 > changing characterThumbnail to characterThumbnailURL to account for IBOutlet UIImageView container's new "load(withURL: ) extended method
 > now what happens when I put viewDidLoad > tableView's delegate & datasource definitions outside the task - does it load faster @ boot?
 >> doesn't work, in fact I think I put that in the Task {} because assigning the delegate before the API call completed was giving me issues, moving back.
 
 > moving UIImageView's extended load func to CharacterSelectViewCell - where it makes more sense
 
 > PROBLEM : [Character] not getting read, problem = Character struct, but I'm not sure where
 >> GOAL: Get characters populated on AllCharactersVC (confirm image)
 
 12.31
 > thinkin i wired my enums up incorrectly
 
 > GOT IT, there's no value (null) for the 'deck' of some of the characters, but i thought i already accounted for that? do even the enum vals need to be optional?
 
 >> no, enums don't need optionals. the problem was w the values in each key "deck" & "description" being "null" in some places
 >> so I used method container.decodIfPresent instead of container.deode for each prop's init in the Character model
 >>> BUT NOW I'm running into an old issue where I lose the selected publisher in AllCharactersVC @ just after "let filteredResults = ..."
 >>> BUT TODAY WAS STILL A SUCCESS, b/c I accounted for one of my CodingKeys missing an assoc. value with the .decodIfPresent property in my model
 
 > GOALS
 >> search: "results dissapearing after filtering swift stack overflow"
 >> get filtered results to stop dissappearing
 >> see if decodIfPresent, keeps that "null" error from throwing - done
 >> populate the AllCharactersVC w data that is for sure coming in, but getting lost @ the filter stage
 
 > quick detour to stack overflow > apple conference vid
 >> need to research mutating a var right way so I can get rid of that "in concurrently executing code" error
 >> get rid of error (via actors (?) ?) > print results.results > fill CharactersVC
 >> https://stackoverflow.com/questions/74372835/mutation-of-captured-var-in-concurrently-executing-code
 
 01.01.24
 > researching concurrency (try docs 1st) [research generics simult.]> researching actors (for passing mutating reference type vars; try docs 1st)) > get rid of error via actors > print results.results > fill CharactersVC
 >> (concurrency WWDC vid) https://developer.apple.com/videos/play/wwdc2022/110350
 >> (concurrency docs) https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/
 
 >> (generics docs) https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/
 
 >> (actor WWDC vid) https://developer.apple.com/videos/play/wwdc2022/110351/
 >> (actor docs? check if this is right) https://developer.apple.com/documentation/swift/anyactor
 
 > see above steps. reading concurrency docs @ "You can also mix both of these approaches in the same code."
 
 01.03.24
 researching actors (for passing mutating reference type vars; try docs 1st)) > get rid of error via actors > print results.results > fill CharactersVC
 > reviewing actor docs
 >> https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors
 >> @ In contrast, code that’s part of the actor doesn’t write await
 
 01.04.24
 > considering making Task in AllPublishersVC's viewDidLoad a detached Task to see if that speeds things up
 
 > still a bit fuzzy on Actors and Concurrency
 >> I'll go a bit deeper and start using 'cmd + i' swift instruments tool after setting up an Actor for the results variable in the API Caller
 >> get rid of error via actors or detaching the task (?) > print results.results > fill CharactersVC > use swift instruments tool to see where lags are most prominent (this will take time to learn) > address lags using concurrency & task studies >
 > reviewing actor docs
 
 01.05.24
 > reviewing actor & concurrency docs
 >> left off at concurrency docs @ "Because the listPhotos(inGallery:) and downloadPhoto(named:)"
 
 01.06.24
 > getting rid of the task in APICaller.getCharactersAPI
 >> ... so I can configure AllCharactersVC in the viewDidLoad rather than outside the VC like the AllPublishersVC (only successful one so far), but having issues w the inits for both - why didn't any errors get flagged for not having them in my classes
 >> ... anything to do w my init(from decoder) thing? where is that anyways?
 
 01.08.24
 > reviewing init docs
 >>  https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/#Designated-Initializers-and-Convenience-Initializers
 >> @ designated & convenience inits
 
 01.11
 > AllPublishersVC: adding print statement to see if selectedPublisher is being read - initial cast to charactersVC var seems like the main issue
 
 01.12
 > restructuring AllCharactersVC's viewDidLoad & adding viewDidAppear to acct for selectedPublisher prop
 
 >  AllPublishersVC: pushing the AllCharactersVC onto stack instead of setting index but not getting past "inside getCharactersAPI()" - so the call is getting triggered to configure on the viewDidAppear
 
 01.15
 > research UINavigationController THAT's what's nested in the UITabBarController, allowing the tab to b visible @ the bottom @ all times as we navigate,
 >> I just need to figure how to pass data through UINavigationController
 
 01.16
 > adding comments & removing filtering method from configureCharacters(withPublsiher) - a func which may be unnecessary
 
 01.17
 >  using codableDictionary sltn from https://stackoverflow.com/questions/44725202/swift-4-decodable-dictionary-with-enum-as-key
 
 01.18
 > next up, try filtering the query and access it (now w the expected ARRAY type in results) using the &filter=field:value method
 
 01.19
 > comic vine api not cooperating w filtering characters via selected publisher (for the time being); So I'll change the app's setup to lead the user to a list of issues related to the selected publisher and maybe I'll include a search function that filters the issues based on characters or sumn'
 
 01.20
 > but there's still the matter of the payload's result housing a dictionary instead of an array
 > so the real question is - how do I decode a Dictionary<String, [Any]> when enums can only accept a raw value type 
 
 01.23
 > GOT IT!!!
 >> after reading https://www.hackingwithswift.com/forums/swiftui/building-the-structs-for-api/7156
 > changed APICharactersResponse result type to hold a dictionary w one key of type String and an array of type Character as the value:
 >> let results: [String: [Character]]
 >> no nested keys/enums necessary past the CodingKeys
 > return decodedJSON.results["characters"]!
 
 > changing APICharactersResponse from var back to const
 
 01.24
 > AllPublishersVC
 >> FIXED the "cells won't populate until I scroll" problem by putting the view.addSubview(tableView) line in the task with its accompanying delegate/datasource/frame logic
 
 Task {
     await configurePublishers()
     view.addSubview(tableView)
     tableView.delegate = self
     tableView.dataSource = self
     tableView.frame = view.bounds
 }
 
 01.25
 > so i dont need an IBOUTLET to transfer the data from tab to tab, but instead i need just a normal prop within allcharacttersVC, but how would I access that prop? also, lastly, selectedPublisherDetailsURL in allcharactersVC is not a computed prop
 
 > MainTabBarVC: I think both publisher vasrs are still empty when the configureCharacters call is made. how to update this / make it a computed prop? do computed props work for UITabBarControllers?
 
 01.26
 > removing initializer from AllCharactersVC in favor of handling setup in said VC instead of the MainTabBarVC
 --------------------------
 
 */





