//
//  PersistenceManager.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/9/23.
//

import UIKit

enum PersistenceActiontype {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let bookmarx             = "bookmarx"
        static let issues               = "issues"
    }
    
    
    static func updateWith(title: Title, actionType: PersistenceActiontype, completed: @escaping (COError?) -> Void) {
        retrieveBookmarx { result in
            switch result {
            case .success(var bookmarx):
                
                switch actionType {
                case .add:
                    guard !bookmarx.contains(title) else {
                        completed(.alreadyInBookmarx)
                        return
                    }
                    bookmarx.append(title)
                case .remove:
                    bookmarx.removeAll { $0.titleName == title.titleName }
                }
                completed(save(bookMarx: bookmarx))
                
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func retrieveBookmarx(completed: @escaping (Result<[Title], COError>) -> Void) {
        guard let bookmarxData = defaults.object(forKey: Keys.bookmarx) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let bookmarx = try decoder.decode([Title].self, from: bookmarxData)
            completed(.success(bookmarx))
        } catch {
            completed(.failure(.unableToBookmark))
        }
    }
    
    
    static func save(bookMarx: [Title]) -> COError? {
        do {
            let encoder = JSONEncoder()
            let encodedBookmarx = try encoder.encode(bookMarx)
            defaults.setValue(encodedBookmarx, forKey: Keys.bookmarx)
            return nil
        } catch {
            return .unableToBookmark
        }
    }
    
    
    // use in didselect method
    static func save(issues: [Issue]) throws {
        // set issue.isFinished in defaults for key
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(issues)
            defaults.setValue(data, forKey: Keys.issues)
        } catch is COError {
            throw COError.cannotRecordCompletion
        }
    }
    
    
    // use in cell for row at method
    static func loadIssues() throws -> [Issue]? {

        guard let data = defaults.data(forKey: Keys.issues) else {
            return nil
        }
        
        let decoder = JSONDecoder()
        do {
            let issues = try decoder.decode([Issue].self, from: data)
            return issues
        } catch let error {
            throw error
        }
    }
    
//    static func saveCellAccessory(forIssue issue: Issue) {
//        defaults.set(cellAccessory, forKey: Keys.cellAccessory)
//    }
//    
//    
//    static func loadAccessory(forIssue issue: Issue) -> UITableViewCell.AccessoryType {
//        guard let data = defaults.da
//    }
   
}
