//
//  PersistenceManager.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/9/23.
//

import UIKit

enum PersistenceManager
{
    static private let defaults = UserDefaults.standard
    
    enum SaveKeys
    {
        static let bookmarx                 = "bookmarx"
        static let completedIssues          = "completedIssues"
    }
    
    enum TitlePersistenceActiontype
    {
        case add, remove
    }

    enum IssuePersistenceActiontype
    {
        case check, uncheck
    }
    
    
    // MARK: TITLE PERSISTENCE
    
    static func updateWith(title: Title, actionType: TitlePersistenceActiontype, completed: @escaping (COError?) -> Void)
    {
        loadBookmarx { result in
            switch result {
            case .success(var bookmarx):
                
                switch actionType
                {
                case .add:
                    guard !bookmarx.contains(title)
                    else
                    {
                        completed(.alreadyInBookmarx)
                        return
                    }
                    bookmarx.append(title)
                case .remove:
                    bookmarx.removeAll { $0.name == title.name }
                }
                completed(save(bookMarx: bookmarx))
                
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func save(bookMarx: [Title]) -> COError?
    {
        let encoder             = JSONEncoder()
        if let encodedBookmarx  = try? encoder.encode(bookMarx) {
            defaults.set(encodedBookmarx, forKey: SaveKeys.bookmarx)
            return nil
        } else {
            return .unableToBookmark
        }
    }
    
    
    static func loadBookmarx(completed: @escaping (Result<[Title],COError>) -> Void)
    {
        if let dataToDecode     = defaults.object(forKey: SaveKeys.bookmarx) as? Data {
            do {
                let decoder     = JSONDecoder()
                let bookMarx    = try decoder.decode([Title].self, from: dataToDecode)
                completed(.success(bookMarx))
            } catch {
                completed(.failure(.unableToLoadBookmarx))
            }
        }
    }
    
    
    // MARK: ISSUE PERSISTENCE
    
    static func updateWith(issue: Issue, actionType: IssuePersistenceActiontype, completed: @escaping (COError?) -> Void)
    {
        loadCompletedIssues { result in
            switch result
            {
            case .success(var issues):
                
                switch actionType
                {
                case .check:
                    issues.append(issue)
                case .uncheck:
                    issues.removeAll { $0.name == issue.name }
                }
                completed(save(completedIssues: issues))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    
    static func save(completedIssues: [Issue]) -> COError?
    {
        let encoder         = JSONEncoder()
        if let encodedData  =  try? encoder.encode(completedIssues) {
            defaults.set(encodedData, forKey: SaveKeys.completedIssues)
            return nil
        } else {
            return .failedToSaveProgress
        }
    }
    
    
    static func loadCompletedIssues(completed: @escaping (Result<[Issue],COError>) -> Void)
    {
        if let dataToDecode         = defaults.object(forKey: SaveKeys.completedIssues) as? Data {
            let decoder             = JSONDecoder()
            do {
                let completedIssues = try decoder.decode([Issue].self, from: dataToDecode)
                completed(.success(completedIssues))
            } catch {
                completed(.failure(.failedToLoadProgress))
            }
        }
    }
}
