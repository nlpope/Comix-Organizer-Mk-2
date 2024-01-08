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
    
        //consider making this a detached task to get it off the Main Actor thread into a top-level background thread
        //Task.detached(priority: .background)
        Task {
            await configurePublishers()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.frame = view.bounds
        }
        
       
       
    }
    
    //should i re-add "private" to below? benefit?
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
        cell.textLabel?.text = publishers[indexPath.row].name
        
        return cell
    }
    
    //delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(publishers[indexPath.row].name)")
//        tableView.deselectRow(at: indexPath, animated: true)
        let allCharactersVC = AllCharactersViewController
        let publisher = publishers[indexPath.row].name
        print("didSelect publisher var : \(publisher)")
        let vc = AllCharactersViewController()
        
        Task {
            print("about to configure with: \(publisher)")
            await vc.configureCharacters(withPublisher: publisher)
            //how to navigate/light up the characters tab, - see Task > configure(with... note in AllCharactersVC
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
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 API CALLS & NETWORK - also see "concurrency"
 > API CALLS & NETWORK
 >> default = async await
 >> be wary of AlamoFire, it does not support async await (see senpai link below)
 
 --------------------------
 >> why is async await (structured concurrency - see "concurrency") preferred over new swift 5.5 completion handlers?
 >>> note: most probs below are contributed to new "Result" enum
 >>> avoids deep nesting (pyramid of doom) that completion handlers are prone to
 >>> more readable
 >>> "Switch"ing through the results & weak references no longer needed
 >>> transition from sync to asyncy context is clearer
 >>> opens up world of Swift Actors (helps avoid data races & concurrency problems)
 
 --------------------------
 > HELPFUL LINKS + HOW TO CONVERT
 >> https://swiftsenpai.com/swift/async-await-network-requests/ (start here)
 >> https://developer.apple.com/forums/thread/712303
 >> https://www.avanderlee.com/swift/async-await/
 1. just set up the APICaller using the "async throws" method (first link above)
 2. ... then, when calling it in the VC, mark the (configure) func calling the async method as "async" as well
 2a. Also, this configure func is where you will handle your filtering should it be necessary
 3. up in the ViewDidLoad, wrap the final reference in a Task {...} so things get hashed out in order
 3. ... this task should contain a "try? await" statement wrapped in a results var where the "shared" func is finally called
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 CLOSURES
 > Group code that executes together, without creating a named function.
 
 > example (syntax):
 { (parameters) -> (return Type) in
    statements
 }
 
 > https://docs.swift.org/swift-book/documentation/the-swift-programming-language/closures/
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 CONCURRENCY (ACTORS, ASYNC, SENDABLE, TASKS)
 > concurrency = code running at the same time / parallel to each other while suspending operations that are waiting for an external system (like an API call)
 >> alternative to (deeply nested) completion handlers / closures
 --------------------------
 CONCURRENCY - ACTORS
 > safely share information between concurrent code
 >> pineapples, chickens, boats & islands (UIslands)
 > like classes, actors are reference types
 >> meaning they require an init
 >> though, unlike classes, actors allow only one task to access their mutable state at a time, which makes it safe for code in mult. tasks to interact w the same instance of an actor
 >> when you access a MUTABLE prop (VAR NOT LET) or method of an actor, you use "await" to mark the potential suspension point.
 > example (set up):
 actor TemperatureLogger {
     let label: String
     var measurements: [Int]
     private(set) var max: Int


     *init(label: String, measurement: Int) {
         self.label = label
         self.measurements = [measurement]
         self.max = measurement
     }
 }
 
 //separate file
 let logger = TemperatureLogger(label: "Outdoors", measurement: 25)
 //why not 'async let' here? becuse TemperatureLogger is an actor not an async func. This would contain 'async let' if the value after the '=' were instead an async func within TemperatureLogger() (?)
 *print(await logger.max)
 // Prints "25"
 
 > https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Actors
 > (wwdc video) https://developer.apple.com/videos/play/wwdc2022/110351/
 --------------------------
 CONCURRENCY - ASYNC / ASYNCHRONOUS CALLS
 > await = "leave this block of code alone and go do other things, when the thing behind the await returns a value, the rest of the code under the await can continue to run"
 >> This is also called yielding the thread because, behind the scenes, Swift suspends the execution of your code on the current thread and runs some other code on that thread instead.
 
 > synchronous (blocking architecture) = sequential funcs: "i'll wait for the last guy to finish before I begin"
 > asynchronous (non-blocking architecture) = non-sequential funcs that suspend execution of lines below it until a value is returned. This also lets concurrently running code (usually elsewhere) keep running while this code waits for the func's result to be ready: "i'll run at the same time as the other guy and can be suspended / resumed partway through"
 > await  = suspension point (execution will pause) on isolated thread til code carries out completely. Though, non-async code around it carries on
 
 > example (before async / using deeply nested completion handler):
 listPhotos(inGallery: "Summer Vacation") { photoNames in
     let sortedNames = photoNames.sorted()
     let name = sortedNames[0]
     downloadPhoto(named: name) { photo in
         show(photo)
     }
 }
 
 > example (after async):
 func listPhotos(inGallery name: String) async -> [String] {
     let result = // ... some asynchronous networking code ...
     return result
 }
 
 let photoNames = await listPhotos(inGallery: "Summer Vacation")
 let sortedNames = photoNames.sorted()
 let name = sortedNames[0]
 let photo = await downloadPhoto(named: name)
 show(photo)
 
 ASYNC CALL METHODS
 METHOD 1
 > store async funcs in constants (not mutable) marked w "async let" (parallel work) = "Faster. I'll download all three at the same time. Write 'await' each time you use said constant. The code carries on while I do this"
 >> 'async let' implicitly creates a child task
 >> example
 async let firstPhoto = downloadPhoto(named: photoNames[0])
 async let secondPhoto = downloadPhoto(named: photoNames[1])
 async let thirdPhoto = downloadPhoto(named: photoNames[2])
 
 let photos = await [firstPhoto, secondPhoto, thirdPhoto]
 show(photos)
 
 METHOD 2
 > calling async funcs w "await" (sequential work) = "Slower. Since value IS needed on next line, I'll knock these out 1 at a time, sequentially. The code carries on while I do this, but only one call to the async func is made @ a time"
 >> example
 let firstPhoto = await downloadPhoto(named: photoNames[0])
 let secondPhoto = await downloadPhoto(named: photoNames[1])
 let thirdPhoto = await downloadPhoto(named: photoNames[2])

 let photos = [firstPhoto, secondPhoto, thirdPhoto]
 show(photos)

 > https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/#Defining-and-Calling-Asynchronous-Functions
 
 --------------------------
 CONCURRENCY - TASKS {...}
 > use (in conjunction w 'await') whenever you call an async func
 >> not always dependant on 'Task' keyword - 'async let' also produces Tasks
 > closures that only accepts values conforming to the @Sendable protocol
 > executes code inside in order / sequentially
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
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
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 ENUMS
 > "I only want a certain range of options available here wrapped in a custom type to avoid mispelling or putting "North" where "Monday" should go
 >  the problem = mistakes can be made when setting up vars
 var selectedDay = "Monday"
 selectedDay = "Tuesday"
 selectedDay = "January" - oops, that's a month, but still compiles
 or how about...
 selectedDay = "Friday " - oops, extra space, but still compiles
 
 > the sltn = we wanna set up a CUSTOM TYPE so typos / invalid values aren't possible
 enum Day {
    case monday
    case tuesday
    case wednesday
    ...
 }
 >> NOW, like a boolean, this new custom type "Day" only holds a small range of possible values
 
 HOW TO WIRE IT UP
 > enums are accessed/triggered in he init(from decoder: Decoder) just below the enums
 let values = try decoder.container(keyedBy: CodingKeys.self)
 
 > then, you can go deeper into nest by linking enums:
 let publisherNest = try values.nestedContainer(keyedBy: PublisherKeys.self, forKey: .publisher)
 
 //then, reach into that nested container and decode the final vars you want
 publisherID = try publisherNest.decode(Int.self, forKey: .publisherID)
 
 ERROR SLTNS & IMPORTANT RULES
 > always start w plural "CodingKeys", then as you reach into nested containers, use singular naming convention
 > ERROR = nested container contains a null / nil value?
 >> in the OG model, just decode using .decodeIfPresent instead of .decode
 >> https://stackoverflow.com/questions/55183539/ignore-null-object-in-array-when-parse-with-codable-swift
 
 MISCELLANEOUS LINKS
 > Paul Hudson YT explanation
 >> https://www.youtube.com/watch?v=bwqbf-1_7gE
 > see comix organizer mk 2 [Character model, AllCharactersVC, CharacterSelectViewCell ]+ docs on encoding & decoding containers
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 GENERIC FUNCTIONS
 > "I accept this type/placeholder type"
 > used when a function's accepted type(s) are subject to change
 
 > example (1st = non-generic, 2nd = generic):
 func swapTwoInts(_ a: inout Int, _ b: inout Int)
 func swapTwoValues<T>(_ a: inout T, _ b: inout T)
 >> where arbitrary placeholder <T> = "my accepted type can change based on my params, but those params better have the same type
 
 >> example 2:
 func withTaskGroup<ChildTaskResult, GroupResult>(
     of childTaskResultType: ChildTaskResult.Type,
     returning returnType: GroupResult.Type = GroupResult.self,
     body: (inout TaskGroup<ChildTaskResult>) async -> GroupResult
 ) async -> GroupResult where ChildTaskResult : Sendable
 > where ChildTaskResult & GroupResult = placeholders who's types are to be determined in func body
 > https://docs.swift.org/swift-book/documentation/the-swift-programming-language/generics/
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
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
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 IN-OUT FUNC PARAMETERS
 > "I wanna mutate a func's params & have that change persist when the func exits"
 > params are 'let' constants by default
 > so trying to change param values in body of funcs = compile time error
 > if you want changes to persist outside of func, define parameter as in-out
 
 >> example:
 func swapTwoInts(_ a: inout Int, _ b: inout Int)
 >> where a & b can now be mutated
 >> https://docs.swift.org/swift-book/documentation/the-swift-programming-language/functions/#In-Out-Parameters

 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 INITS
 > initialize parameters defined in a struct,  class or extension
 >> classes = mandatory
 >> structs = don't need them / swift auto adds them @ compile time
 
 STANDARD INITS
 > most straightforward - initialize the values you define @ runtime
 >> failable, so put a "!" after the final parenthesis of the init if need be
 
 > classes = mandatory
 > structs = free init (not mandatory)
 
 > example (set up)
 class Hero {
    codeName: String
    publisher: String
    age: Int
    init(codeName: String, publisher: String, age: Int) {
        self.codeName = codeName
        self.publisher = publisher
        self.age = age
    }
 }
 
 > example (execution)
 var clint: Hero(codeName: "Hawkeye", publisher: "Marvel", age: 38)
 >> just put the class/struct name in front of the init, that's all
 
 INITS - REQUIRED INITS
 > required = every subclass of the class must implement that initializer
 >> how is this different from the standard init
 
 INITS - OVERRIDE INITS
 > ?
 
 INITS - CONVENIENCE INITS
 > ?
 > example (set up)
 extension UIImage {
     enum AssetIdentifier: String {
         case Search = "Search"
         case Menu = "Menu"
     }
     convenience init(assetIdentifier: AssetIdentifier) {
         self.init(named: assetIdentifier.rawValue)!
     }
 }
 
 > example (execution)
 UIImage(assetIdentifier: .Search)

 HELPFUL LINKS
 > https://stackoverflow.com/questions/32544366/swift-uiimage-extension
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 JSON DATA IS NESTED: ENCODING & DECODING HOW TO
 > encoding & decoding nested dictionaries & arrays
 >> just decode for the final, primitive value & navigate levels using enums (see below)
 >> https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types

 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 LAUNCH SCREEN & APP ICON
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
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 MVC & MV(C)VM ARCHITECTURES
 > MVC = default / preferred
 >> low complexity apps, simple arch. w plenty of documentation/support; most common
 > MVVM (or MVCVM)
 >> more complex apps that need reusable view models
 >> I'll research more on this come ComixOrganizer Mk. 3
 
 >  HELPFUL LINKS
 >> https://scottlydon.medium.com/the-differences-between-mvc-and-mvvm-swift-f1936b0bab14
 >> https://stackoverflow.com/questions/667781/what-is-the-difference-between-mvc-and-mvvm/58796188#58796188
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 PRIVATE(SET) & PRIVATE(GET) - OR ACCESS CONTROL
 > PRIVATE(SET)
 >> only code inside the class/struct/actor/scope can update this prop
 >> in the init( ), you cannot set private(set)'s. The best you can do is give this prop an initial value or, in the internal init( ), set this prop equal to one of your non-private, "init-able" props
 >> example:
 actor TemperatureLogger {
     let label: String
     var measurements: [Int]
     **private(set) var max: Int


     init(label: String, measurement: Int) {
         self.label = label
         self.measurements = [measurement]
         self.max = measurement
     }
 }
 
 > PRIVATE(GET)
 >> ?
 
 > https://docs.swift.org/swift-book/documentation/the-swift-programming-language/accesscontrol/#Getters-and-Setters
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 REFERENCE TYPES VS VALUE TYPES (CLASSES VS STRUCTS)
 > REFERENCE TYPES
 >> shares a single copy of (pointer to) the object's data
 >>> see chicket on a boat: https://developer.apple.com/videos/play/wwdc2022/110351/
 >> e.g.  classes
 >> DOES  require init
 >> IS NOT conformable to SENDABLE protocol
 >>> unless all of its props are NON-MUTABLE / NOT CHANGEABLE
 >> SPECIAL NOTE: ACTORS ARE ALSO REFERENCE TYPES: SEE ACTORS SECT.

 
 > VALUE TYPES
 >> shares a unique COPY of the obecjt's data
 >>> see pineapple on a boat: https://developer.apple.com/videos/play/wwdc2022/110351/
 >> e.g. structs & enums
 >> DOES NOT require init
 >> conformable to SENDABLE protocol
 >>> unless one of its props is of type class / not sendable conforming

 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 STORYBOARD: HOW TO REMOVE IT TO CODE INTERFACE PROGRAMMATICALLY
 > https://medium.com/@yatimistark/removing-storyboard-from-app-xcode-14-swift-5-2c707deb858

 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 UIIMAGEVIEW & UIIMAGE
 > UIImageView = stores UIImage
 >> houses a ".image" property
 
 > UIImage = raw image
 >> https://stackoverflow.com/questions/8070805/difference-between-uiimage-and-uiimageview
 
 > pulling a UIImage from a url
 >> ?
 >> https://www.hackingwithswift.com/example-code/uikit/how-to-load-a-remote-image-url-into-uiimageview

 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 COMMON ERROR SLTNS
 > simulators disappeared?
 >> restart computer
 >> https://developer.apple.com/forums/thread/120250

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
 >>  https://docs.swift.org/swift-book/documentation/the-swift-programming-language/initialization/#Optional-Property-Types
 >> @ If your custom type has a stored property that’s logically allowed to have “no value”
 --------------------------
 
 */





