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
        static let issueProgress        = "issueProgress"
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
    
    
//    static func updateWith(issue: Issue, actionType: PersistenceActiontype, completed: @escaping (COError?) -> Void) {
//        retrieveProgress { result in
//            switch result {
//            case .success(var issues):
//                
//                switch actionType {
//                case .check:
//                   
//                case .remove:
//                    bookmarx.removeAll { $0.titleName == title.titleName }
//                }
//                completed(save(bookMarx: bookmarx))
//                
//                
//            case .failure(let error):
//                completed(error)
//            }
//        }
//    }
    
    
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
    
    
    static func retrieveProgress(completed: @escaping (Result<[Issue], COError>) -> Void) {
        guard let issueData = defaults.object(forKey: Keys.issueProgress) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let issues  = try decoder.decode([Issue].self, from: issueData)
            completed(.success(issues))
        } catch {
            completed(.failure(.failedToLoadProgress))
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
    static func saveProgress(forIssues issues: [Issue]) throws {
        do {
            let encoder = JSONEncoder()
            let encodedIssues = try encoder.encode(issues)
            defaults.setValue(encodedIssues, forKey: Keys.issueProgress)
            print("progress saved")
            return
        } catch {
            throw COError.failedToRecordCompletion
        }
    }
}
