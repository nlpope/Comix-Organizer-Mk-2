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
        guard let url = URL(string: "\(Constants.baseURL)/publishers/?api_key=\(Constants.API_KEY)&format=json&field_list=name,publisher,id,image,deck,birth,api_detail_url,aliases") else {
            //&field_list=name,id
            throw APIError.invalidURL
        }
        //async variant of urlsession - may suspend code, hence the await
        let (data, _) = try await URLSession.shared.data(from: url)
        
        print("json decoded")
        let decodedJSON = try JSONDecoder().decode(APIPublishersResponse.self, from: data)
                
        return decodedJSON.results.sorted(by: {$1.publisherName > $0.publisherName})
    }
    
    func getPublisherTitlesAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Volume] {
        //publisherTitles = volumes in API
        print("inside getPublisherTitlesAPI()")
        guard let url = URL(string: "\(publisherDetailsURL)?api_key=\(Constants.API_KEY)&format=json&field_list=volumes&field_list=characters") else {
            throw APIError.invalidURL
        }
        print(url)

        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decodedJSON = try JSONDecoder().decode(APIVolumesResponse.self, from: data)
        
        print("json decoded")
                
        return decodedJSON.results.sorted(by: {$1.volumeName > $0.volumeName})
    }
    
    func getCharactersAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Character] {
        
        guard let url = URL(string: "\(publisherDetailsURL)?api_key=\(Constants.API_KEY)&format=json&field_list=characters") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print("inside getCharactersAPI & the data was pulled from the URL. about to decode")

        //DELETE THIS AFTER PROBLEM CHILD ERR IS DEALT WITH
       
    
        let decodedJSON = try JSONDecoder().decode(APICharactersResponse.self, from: data)
        
        print("inside getCharactersAPI & JSON was successfully decoded")
        
        return decodedJSON.results["characters"]!.sorted(by: {$1.characterName > $0.characterName})
        
        
              
    }

}


/**
 ARCHIVED CODE
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 func getCharactersAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> Dictionary<String, [Character]>
 
 --------------------------
 print("inside getCharactersAPI & the guard let threw no error. About to start URLSession to pull data for decoder. URL = \(url)")
 */
