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
    //removing &field_list=name,id,publisher from url - move back if probs
    func getPublishersAPI() async throws -> [Publisher] {
        print("inside getPublishersAPI()")
        guard let url = URL(string: "\(Constants.baseURL)/publishers/?api_key=\(Constants.API_KEY)&format=json") else {
            //&field_list=name,id
            throw APIError.invalidURL
        }
        //async variant of urlsession - may suspend code, hence the await
        let (data, _) = try await URLSession.shared.data(from: url)
        let results = try JSONDecoder().decode(APIPublishersResponse.self, from: data)
        
        return results.results.sorted(by: {$1.name > $0.name})
    }
    
    func getCharactersAPI() async throws -> [Character] {
        print("inside getCharactersAPI()")
        guard let url = URL(string: "\(Constants.baseURL)/characters/?api_key=\(Constants.API_KEY)&format=json") else {
            throw APIError.invalidURL
        }
        //ARE WE EVEN GETTING HERE?
        print("The guard let threw no error. About to start URLSession to pull data for decoder")
        let (data, _) = try await URLSession.shared.data(from: url)
        let results = try JSONDecoder().decode(APICharactersResponse.self, from: data)
        
//        print("THE DECODER WORKED - DATA DECODED & ABOUT TO RETURN RESULTS.RESULTS TO ALLCHARACTERSVC'S CONFIGURECHARACTERS FUNC. FIRST RESULT = \(results.results.first!)")
//        print("inside getCharactersAPI() & results.results = \(results.results)")
        return results.results
        //.sorted(by: {$1.characterName > $0.characterName})
              
    }

}

