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
    case invalidURL
    case failedToGetData
}

class APICaller {
    static let shared = APICaller()
    
//    func getPublishers(completion: @escaping (Result<[Publisher], Error>) -> Void)
    func getPublishers() async throws -> [Publisher] {
        print("inside getPublishers()")
        //below used to be guard let w an else, but func now returns non-void
        guard let url = URL(string: "\(Constants.baseURL)/publishers/?api_key=\(Constants.API_KEY)&format=json&field_list=name,id,publisher") else {
            //&field_list=name,id
            throw APIError.invalidURL
        }
        //async variant of urlsession - may suspend code, hence the await
        let (data, _) = try await URLSession.shared.data(from: url)
        let results = try JSONDecoder().decode(APIPublishersResponse.self, from: data)
        
        return results.results.sorted(by: {$1.name > $0.name})
    }
    
    func getCharacters() async throws -> [Character] {
        print("inside getCharacters()")
        
        guard let url = URL(string: "\(Constants.baseURL)/characters/?api_key=\(Constants.API_KEY)&format=json") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        //problem child = below
        //do catch block for testing only then pull out & remove dummy return
//        do {
//            let results = try JSONDecoder().decode(APICharactersResponse.self, from: data)
//
//            return results.results.sorted(by: {$1.name > $0.name})
//
//        } catch {
//            print("specific json decoder error: \(error)")
//        }
        let results = try JSONDecoder().decode(APICharactersResponse.self, from: data)

        return results.results.sorted(by: {$1.publisherName > $0.publisherName})

    }

}

//MARK: ADD GIST EXTENSIONS HERE
//source: https://stackoverflow.com/questions/44603248/how-to-decode-a-property-with-type-of-json-dictionary-in-swift-45-decodable-pr
