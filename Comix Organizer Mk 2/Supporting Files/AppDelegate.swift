//
//  AppDelegate.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //first thing that happens (before the viewdidload) when app boots
        print("didFinishLaunchingWithOptions")
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        //do sumn to prevent user from loosing data when they get a leave the app (e.g. get a call, etc.)
        print("application will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("application did enter background")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("application will terminate")
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    //CORE DATA STEP 1
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "Comix_Organizer_Mk_2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
               
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

//MARK: NOTES SECTION
/**
 swift @ version: 5.10.1
 xcode @ version: 15.4
 --------------------------
 SHORTCUTS (GENERAL):
 
 *  access quick actions (XCode 15) = cmd + shift + a
 > use to access 'minimap'
 > use to quick change 'theme' - current = midnight
 *  bookmark goals by right clicking a line
 > more preferably, type '#warning("message")' instead to have 'return to' items clear & present
 *  clean XCode build folder = cmd + shift + K
 *  create new code snippets: right click + "create code snippet"
 *  duplicate a line = cmd + D
 *  edit multiple lines at once: control + shift + click away then start typing
 > or opt + click & drag down
 *  edit this / saved code snippet: cmd + shift + L
 *  emoji keyboard: cmd + cntrl + spacebar 😎
 *  force quit on mac: cmd + opt + esc
 *  importing UIKit also imports Foundation (never import Foundation if UIkit is in play)
 *  new XCode internal tab = cmd + ctrl + T
 > hotkey for this = opt + click any file in your project folder
 *  storyboard object list: cmd + shift + L (double check?)
 
 SHORTCUTS (HIDE / REVEAL PANES):
 
 *  hide/reveal debug & console area = cmd + shift + Y
    > hide/reveal console = cmd + shift + c
 *  hide/reveal left pane = cmd + 0
 *  hide/reveal right pane = cmd + shift + 0
 *  hide/reveal preview window = cmd + shift + enter
 *  hide/reveal minimap = cntrl + shift + cmd + m || access quick actions > type 'minimap'
 
 *  source = see Stanford: https://www.youtube.com/watch?v=CRxHhx_pubY&list=PL3d_SFOiG7_8ofjyKzX6Nl1wZehbdiZC_&index=3&ab_channel=CS193P
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 
 HELPFUL TIPS:
 
 *  App Icons & Image sets:
    >  https://www.appicon.co/#app-icon
    >  https://www.appicon.co/#image-sets
    >> mind light & dark views: https://developer.apple.com/documentation/uikit/uiimage/providing_images_for_different_appearances
 
 *  Code formatting:
    > order = vars/lets, init methods, view lifecycle methods (VDL), funcs
    > 1 space after imports
    > 1 space BETWEEN class / struct / enum declarations
    > 1 space AFTER class / struct / enum declarations
    > 2 spaces after vars just before methods
    > 2 spaces between funcs
    >> no spaces on 1st line after func declaration
 
 *  Debugging
    > see Stanford: https://www.youtube.com/watch?v=CRxHhx_pubY&list=PL3d_SFOiG7_8ofjyKzX6Nl1wZehbdiZC_&index=3&ab_channel=CS193P
 
 *  DispatchQueue-ing to main thread:
    > updating UI? - switch to main thread
    >> ex: DispatchQueue.main.async { self.image = image }
 
 *  Folders = instead of MVC, MVVM, etc. start with:
    > Extensions - "...+Ext"
    > Utilities (error msgs, constant enums, UIHelpers) - "...+Utils"
    > Managers
    > Models
    > CustomViews
    > Screens (VCs)
    > Support (App/Scene Delegate, Assets, the rest)
    >> except info.plist, leave this outside/alone
 
 *  Human interface guidelines: https://developer.apple.com/design/human-interface-guidelines
 
 *  MVC = "Does my View Controller need to know about this?":
    >  basically if you see NO GREEN TEXT (ref's to props created in the VC) in the func, it can be refactored to   another file.
    >> the background color, border width, & corner radius of a container for an alert? No; Include in separate  UIView
    >> NSLayoutContstraints for the container? Yes.
    >> if a refactored view was referenced in the OG func and is throwing an error once you move it, pass in the view using: func functionName(in view: UIView) { }
 
 *  Network calls:
    > best to keep your .success, .failure & switch statement cases contained to 1-2 readable lines of code - factor out if need be. for example:
    >>    case .success(let followers):
    updateUI(with: followers)
    >> NOTE: not always possible, if it's 4 lines & depends on a complex completion handler, so be it
 
 *  Padding & constraints:
    >  whatever your fontSize is set to, give your label 4 extra points of padding in the NSLayoutConstraints below it  to account for letters that dip below baseline (y, j, g, etc)
 
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 
 PROJECT NOTES:
 *  Biggest Struggles:
    > delegate & protocol method placements (who was calling what)
    
    > completion handlers vs task (async await)
    >> more specifically the placement of keywords: async throws, Task @ call site vs @ func declaration, & do/catch block placement @ call site vs @ func declaration
    
    > hash collision induced diffable datasource crash when loading new publishers (see note 14 below)
 --------------------------

 *  Publisher
    1. Coding keys steps:
    > start w plural "CodingKeys" for top level enums & expected nest name cases...
    > then move to singular naming convention if nest delves even deeper - docs
    > finally, after the enum setup, in your init(from decoder), link the top level key containing the nested container using the corresp. top level case - docs
 
    2. for nested items, start w final dest. then declare wrapper prop(s) in enum(s)
 
    3. below must be named 'results' as it "maps" to JSON's 'results'
 
 *  AllPublishersVC: Archived Notes
    4. see https://docs.google.com/document/d/1QzdvsaMTDFkR5K3aL_i9YvgTQeATA5c-7xIW7G_8PG4/edit
 
 *  AllPublishersVC
    5. this is how the old tableView was set up @ the top. It's worth noting since it's unlike how I set up the tableView for the FavoritesListVC in GHFollowers
    
    let tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
    ( )
  
 *  PopUpWindowChildVC
    7.
 
 *  COLoadAnimationVC
    8. PROBLEM: WHY ARE MY DOTS LINED UP ON TOP OF EACH OTHER INSTEAD OF LAID OUT HORIZONATALLY & SPACED?
    > sltn: I had the 'animate' prop on the VC's initializers set to false
 
 *  AllPublishersVC
    9. OG logic for getPublishers( ) in place of everything under guard, let, else { }
    
        if let results = try? await APICaller.shared.getPublishers(page: page) { self.publishers += results } else {
            self.dismissLoadAnimationVC()
            throw COError.failedToGetData
        }
        configureTableView()
 
    10. calling configureTableView() here resulted in blank page when I was working with a tableView. I wonder why?
 
 *  APICaller & AllPublishersVC - Returning Error vs Throwing Error
    11.  async variant of urlsession - may suspend code, hence the await
    > (data, _) = type (Data, [unnamed] URLResponse [that throws its own error])?
    > ... i.e. it's equiv. to COError.failedToGetData - no need to handle that below
 
    12a. think the reason I don't need to return optional type here is b/c 'throw' accts for error & nil is impossible (?)
    12b. ERROR CORRECTION: refactored APICaller.getAllPublishers by removing incorrect do/try/catch block & including said block @ call site (AllPublishersVC)
    > also, removing the '?' after the 'try' resulted in the 'results' not having to be force unwrapped, which allowed the catch block to be reached
    > I also was incorrectly declaring 'async throws' @ the call site. Removing that meant I only needed to include the 'Task' concurrency wrapper inside the call site func, not the VDLoad
    > see: https://medium.com/@kuopingl/returning-error-vs-throwing-error-in-swift-8d3657e1330d
 
 *  Publisher
    13. Equatable is the base protocol for the Hashable protocol
    
 *  AllPublishersVC
    14. PROBLEM: I was getting an Assertion Failure crash from the diffable datasource when trying to load more publishers, incrementing the 'offset' param by 1
    > SLTN: I was setting the offset to increment by 1 when that only bumps out the very top result, leaving the rest of the 99 untouched (+ the 1 new result), resulting in a hash collision which wouldn't have sparked the crash, but WOULD have affected the search function's efficiency.
 
    > What I needed to do was increment the 'offset' param by 100 @ a time
 --------------------------
 
 
 */

#warning("previously on: finish comixmk2 refactor w diffable datasource > noahpope.me portfolio after checking hostgator progress")
