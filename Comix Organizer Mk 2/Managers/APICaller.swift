//
//  APICaller.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import Foundation

struct Constants {
      static let baseURL = "https://metron.cloud/api"
}

enum APIError: Error {
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
    func getPublishers(completion: @escaping (Result<[Publisher], Error>) -> Void) {
        print("testing 123")
        //S.O. auth process
        let username = "npope@tutanota.com"
        let password = ""
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let url = URL(string: "https://metron.cloud/api/publisher/?format=json") else {return}
//        guard let url = URL(string: "\(Constants.baseURL)/publisher/?format=json") else {return}
        
        var task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
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
        task.originalRequest?.httpMethod = "GET"
        task.originalRequest?.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        task.resume()
    }

}




