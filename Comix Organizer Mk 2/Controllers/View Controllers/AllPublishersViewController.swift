//
//  AllPublishersViewController.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//
//  MAKING THIS THE LOADINGANIMATION DELEGATE (ADD TO OTHER VCs if it works)

import UIKit
//UIKit does NOT make this a SwiftUI project
import CoreData

//this is the HomeViewController / HomeVC
//match API results agains list of most popular publishers (via a set array that I create?) then display that
//03.15: just removed LoadAnimationDelegate pattern & conformance below

class AllPublishersViewController: UIViewController {
       
    private var vcSelectedFromPopUp = ""
    var selectedPublisherName = ""
    var selectedPublisherDetailsURL = ""
    private var publishers = [Publisher]()
    
    let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
        
    //CORE DATA STEP 2
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //get the reference to the shared model (Publisher)
        view.backgroundColor = .systemBackground
        title = "Publishers"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        Task {
            //this works fine (horizontal dots)
            presentLoadingAnimationViewController()
            
            await configurePublishers()
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
            
            dismissLoadingAnimationViewController()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //DISMISS LOADING ANIMATION HERE?
        tableView.frame = view.bounds
    }
    
    //MARK: CONFIGURATION
    func configurePublishers() async {
        //should load animation delegate reside in this func?
        if let results = try? await APICaller.shared.getPublishersAPI() {
            self.publishers += results
        } else {
            print("something went wrong in configurePublishers()")
        }
    }
    
    func presentLoadingAnimationViewController() {
        let loadingAnimationVC = LoadAnimationViewController()
  //03.15: commented out - loadingAnimationVC.delegate = self
        
        //hide the navigation controller & tabs
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.pushViewController(loadingAnimationVC, animated: false)
    }
    
    func dismissLoadingAnimationViewController() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false

        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: DELEGATE & DATASOURCE METHODS
extension AllPublishersViewController: UITableViewDataSource, UITableViewDelegate, PopUpDelegate {
    
    //MARK: DATASOURCE METHODS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publishers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = publishers[indexPath.row].publisherName
        
        return cell
    }
    
    //MARK: DELEGATE METHODS
    //didSelect delegate method(s)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPublisherName = publishers[indexPath.row].publisherName
        selectedPublisherDetailsURL = publishers[indexPath.row].publisherDetailsURL
        
        //trigger pop-up
        var popUpWindowVC: PopUpWindowViewController!
        popUpWindowVC = PopUpWindowViewController(title: "Please Specify", text: "What would you like to see from this publisher?", buttonOneText: "Titles", buttonTwoText: "Characters", selectedPublisherName: selectedPublisherName, selectedPublisherDetailsURL: selectedPublisherDetailsURL)
        //4. the definition - next one below
        //"Great! I'll make myself the delegate and conform to the protocol (by containing the func the protocol requires)"
        
        popUpWindowVC.delegate = self
        self.present(popUpWindowVC, animated: true, completion: nil)
    }
    //5. the handler - end
    //Awesome, now that I'm the delegate, I can provide my own functionality to that required protocol func (with access to all the variables you'll need"
    
    //popup delegate method(s)
    func presentTitlesViewController() {
        let selectedPublisherTitlesVC = SelectedPublisherTitlesViewController()
        
        selectedPublisherTitlesVC.selectedPublisherName = selectedPublisherName
        selectedPublisherTitlesVC.selectedPublisherDetailsURL = selectedPublisherDetailsURL
        
        self.navigationController?.pushViewController(selectedPublisherTitlesVC, animated: true)
        
        //03.15: i just hid the below, does that change anything?
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func presentCharactersViewController() {
        let selectedPublisherCharactersVC = SelectedPublisherCharactersViewController()
        selectedPublisherCharactersVC.selectedPublisherName = selectedPublisherName
        selectedPublisherCharactersVC.selectedPublisherDetailsURL = selectedPublisherDetailsURL
        
        self.navigationController?.pushViewController(selectedPublisherCharactersVC, animated: true)
    }
    
   
    
}

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
 GOALS:
 > URGENT:
 >> I need to find a way to more naturally present & dismiss LoadAnimationVC based on whether or not the AllPublishersVC's tableView is ready - do this in the viewDidLayoutSubviews() method?
 
 >> deliniate duplicate titles by putting (volume # or # of issues) after it, THAT'S where they differ, then the checkable issues will be umbrellaed under said volume on the next VC
 >> add "please wait" spinning animation to allpubVC & selectedpubtitlesVC so user doesn't have to sit through an ambiguous lag
 >> delete duplicate titles (unless they're different somehow)
 >> display popular publishers ONLY, accessing the rest via search
 >> toggler to switch between displaying titles vs characters (affects search func)
 >> colorful, animated template (see templates on github?) for AllCharactersVC > SelectedCharacterVC
 
 > EVENTUALLY:
 >> review the role of VCs: https://developer.apple.com/library/archive/featuredarticles/ViewControllerPGforiPhoneOS/index.html#//apple_ref/doc/uid/TP40007457
 >> review updated version of above
 >> review MVC architecture (from BJ Homer): https://stackoverflow.com/questions/1151422/uiview-vs-uiviewcontroller
 --------------------------
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
 > getting rid of the task in APICaller.getPublisherCharactersAPI
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
 
 01.29
 > Netflix clone not running on simulator either (black screen) must be the sim. try restarting comp (?) then  look up sltns on S.O. after
 >> after that, move the API call into a viewWillAppear (best place)
 
 01.30
 > closest I ever got to a sltn for passing the data...
 >> see https://developer.apple.com/documentation/uikit/uitabbarcontroller/1621185-viewcontrollers
 >> @ the new view controllers are displayed immediately and are not animated into position
 
 >> also see https://forums.developer.apple.com/forums/thread/119037
 
 01.31
 > SUCCESS - characters are populating table in allcharactersVC after selection in allpublishersVC; also changed VC title behavior to match selection
 > link that turned the tide (developer forums): https://forums.developer.apple.com/forums/thread/119037
 
 02.01
 > NEW GOALS:
 >> make initial VC a dummy splash screen identical to the real splash screen & remove (push) it from the stack to reveal the publishers table only AFTER it's populated
 >> figure how to keep user from switching tabs during a Task (e.g. publishers still loading and hits a null error when i switch to charactersVC prematurely
 >> remove teams from the tabs & replace it w series - just include a "Teams" field on the selected character's pushed window if they were on one
 >> overall id like to speed things up - maybe lighten the payload w comicvine's fiilters?
 
 02.02
 > whiteboarding new layout
 
 02.03
 > adding TitlesCharactersTabBarVC - to be pushed onto stack after being configured from publisher's didSelect method
 
 02.06
 > split up VCs & TabBarCs successfullly, just figure a way to push the secondary TabBarC from allpublishersVC
 > next work on deallocating via a de-initializer (?) saving the data to context before we proceed?
 
 02.07
 > reviewing docs & articles on tab bar controllers & passing info btwn them before continuing w setting up the V2 wireframe
 
 > next up, work on changing the appdelegate to match what's in this article
 >> https://makeapppie.com/2014/09/09/swift-swift-using-tab-bar-controllers-in-swift/
 >> already pushed bookmark - proceed
 
 02.09
 > setting up home office
 > whiteboarding: reworking wireframe (possibly switching back to one tab bar vc)
 
 02.10
 > whiteboarding v3 wireframe. this one makes more sense. will implement next session
 
 02.12
 > not gonna touch the app delegate - think that step is unnecessary since all that setup was successfully done in MainTBController
 > instead gonna share the publisher model in the MainTBController
 
 02.14
 > project running super slow
 > look into that - maybe too many tabs open? cause even typing this is slow
 > successsfully set up selectedpublisherVC & pushing it from allpublishersVC
 > wanna change the "comics" in a title to comix
 >> maybe just remove the word "comic" if present
 >> use contains(_:) method for this
 
 02.15
 > MILESTONE: GOT APP TO REPLACE ALL OCCURRENCES OF THE WORD "COMICS" TO "COMIX" NO MATTER WHERE IT IS IN THE TITLE
 
 > need to get a list of the top like 30 comic publishers and make the rest accessible only via search
 >> want an animated pop-up of a character's stats in addition to the comic tracking
 >>> maybe on the charactersVC?
 
 02.20
 > adding popupwindowView to hold popupwindowVC (to be created)
 
 02.21
 > successfully presenting character title pop up delineator, but one button is missing
 
 02.28
 > reading up on passing data using objc selectors
 >> https://developer.apple.com/documentation/swift/using-objective-c-runtime-features-in-swift
 
 02.29
 > using delegation design pattern to set (presnting) AllPublishersVC as deledgate of (presented) PopUpWindowVC; complete w protocol stubs accounting for title click & characters click (to be created)
 >> https://stackoverflow.com/questions/43474872/access-the-presenting-view-controller-from-the-presented-view-controller
 >> left off @ "Next: Make your presenting view controller conform to the protocol
 >> not using storyboards so maybe skip this step or go here: https://stackoverflow.com/questions/36216582/create-and-perform-segue-without-storyboards
 
 03.01
 > narrowed it down to closures and delegates
 >> i will use delegates since Delegation is commonly employed in UI-related tasks, like handling user interactions or customizing behavior in response to certain events.
 >>> https://medium.com/@kohinoorprajapat54/difference-between-closures-and-delegates-in-swift-b9b208e66267#:~:text=In%20summary%2C%20closures%20are%20more,communication%20and%20cooperation%20between%20objects
 
 03.03
 > MILESTONE: successfully displaying volumes for Marvel & DC (maybe I was leaving too early before it populated b/c I didn't change anything)
 >> correction: something did change, I added the filter &field_list=volumes to the api call, for some reason the data loads in an incomplete way w/out it
 
 03.07
 > adding mistakenly omitted "jumpRelativeTime" const to added keyframe & mistakenly omitted call to the animate() func. works fine now, but I need to find a way to more naturally present & dismiss this based on whether or not the AllPublishersVC's tableView is ready
 
 03.09
 > changing name of LoadAnimationVC to LoadAnimationView & in middle of playing w delegation pattern akin to popUpView to get animation to fill whole screen & dismiss when destinationVC's API call  is complete (triggers delegate's dismiss func)
 
 03.12
 > completed setting up delegate pattern for load screen (not yet tested)
 
 03.13
 > this is good - loading animation working as expected after setting delegate up to exist above the datasource and delegate methods listed in the extension (setup vs interaction portions of my code) but i still need to find a way to properly dismiss it & hide the maintbvc tabs @ the bottom during

 03.15
 > SUCCESS - LOADING ANIMATION: I thought the issue was the unnecessary delegate design pattern around the LoadingAnimationVC, and YES that had to go, but the real problem was setting the animation parameter in the navigationController's pushVC method to "false"
 
 > setting up VC for selected title's issues (where check marks come into play)
 
 03.17
 > setting up final VC for title issues - but sumn's going wrong in SelectedTitleIssuesVC > configureTitleIssues() more spec. at the APICaller > let decodedJSON = ...
 
 03.18
 > finished setting up issues struct so SelectedTitleIssuesVC correctly populates
 
 03.21
 > see below link for check marking the cell on click for issues
 >> https://stackoverflow.com/questions/8388136/how-to-remove-the-check-mark-on-another-click
 
 03.22
 > SUCCESS - issue cell checkmarks tested working after accessory edit
 
 04.01
 > working on omitting volumes w an issue count of 0 > work on adding context to save state of checked cells for the selectedTitleIssuesVC
 
 04.06
 > printing title count in hopes to omit publishers w zero titles and titles w zero issues
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 
 
 
 --------------------------
 
 */





