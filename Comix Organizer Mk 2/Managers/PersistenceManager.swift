//
//  PersistenceManager.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/9/23.
//

import UIKit

enum TitlePersistenceActiontype {
    case add, remove
}

enum IssuePersistenceActiontype {
    case check, uncheck
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    enum Keys {
        static let bookmarx                 = "bookmarx"
        static let completedIssues          = "completedIssues"
    }
    
    
    static func updateWith(title: Title, actionType: TitlePersistenceActiontype, completed: @escaping (COError?) -> Void) {
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
    
    
    static func updateWith(issue: Issue, actionType: IssuePersistenceActiontype, completed: @escaping (COError?) -> Void) {
        retrieveCompletedIssues { result in
            switch result {
            case .success(var issues):
                
                switch actionType {
                case .check:
                    issues.append(issue)
                case .uncheck:
                    issues.removeAll { $0.issueName == issue.issueName }
                }
                completed(save(completedIssues: issues))
                
                
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
    
    
    static func retrieveCompletedIssues(completed: @escaping (Result<[Issue], COError>) -> Void) {
        guard let completedIssuesData = defaults.object(forKey: Keys.completedIssues) as? Data else {
            completed(.success([]))
            return
        }
        do {
            let decoder = JSONDecoder()
            let completedIssues = try decoder.decode([Issue].self, from: completedIssuesData)
            completed(.success(completedIssues))
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
    
    
    static func save(completedIssues: [Issue]) -> COError? {
        do {
            let encoder = JSONEncoder()
            let encodedCompletedIssues = try encoder.encode(completedIssues)
            defaults.setValue(encodedCompletedIssues, forKeyPath: Keys.completedIssues)
            return nil
        } catch {
            return .failedToRecordCompletion
        }
    }
}
