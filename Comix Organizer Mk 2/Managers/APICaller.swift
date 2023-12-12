//
//  APICaller.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct Constants {
    static let API_KEY = "b31d5105925e7fd811a07d63e82320578ba699f1"
    static let baseURL = "https://comicvine.gamespot.com/api"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
//    func getPublishers(completion: @escaping (Result<[Publisher], Error>) -> Void)
    func getPublishers() async throws -> [Publisher] {
        print("inside getPublishers()")
        //below used to be guard let w an else, but func now returns non-void
        guard let url = URL(string: "\(Constants.baseURL)/publishers/?api_key=\(Constants.API_KEY)&format=json") else {exit(0)}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(APIPublishersResponse.self, from: data)
//                completion(.success(results.results))
            } catch {
                //instead of printing the err, we're passing in a failure to handle it directly from Home/AllPublisherVC
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }

}




