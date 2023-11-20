//
//  APICaller.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct Constants {
  
    static let API_KEY = "TBD"
    static let baseURL = "https://metron.cloud/api"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getPublishers(completion: @escaping (Result<[Publisher], Error>) -> Void) {
        print("testing 123")
        guard let url = URL(string: "\(Constants.baseURL)/publisher") else {return}
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do {
                let results = try JSONDecoder().decode(MetronPublishersResponse.self, from: data)
                completion(.success(results.results))
                print(results)
            } catch {
                //instead of printing the err, we're passing in a failure to handle it directly from home viewcontroller
                completion(.failure(APIError.failedToGetData))
            }
        }
        
        task.resume()
    }

}




