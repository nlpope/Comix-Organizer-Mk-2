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
        do {
            let decodedJSON = try JSONDecoder().decode(APIPublishersResponse.self, from: data)
                    
            return decodedJSON.results.sorted(by: {$1.publisherName > $0.publisherName})
        } catch {
            print("\(error)")
        }
        let results = try JSONDecoder().decode(APIPublishersResponse.self, from: data)
                
        return results.results.sorted(by: {$1.publisherName > $0.publisherName})
    }
    
    //FORMER PROBLEM CHILD
    //API CALL DOESN'T ALWAYS INCLUDE WHAT USER SELECTS,
    //BEST TO SEARCH VIA SPECIFIC PUBLISHER & RETURN THE CHARACTERS IN THAT ARRAY
    func getCharactersAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> Dictionary<String, [Character]> {
        guard let url = URL(string: "\(publisherDetailsURL)?api_key=\(Constants.API_KEY)&format=json&field_list=characters") else {
            throw APIError.invalidURL
        }
        print("inside getCharactersAPI & the guard let threw no error. About to start URLSession to pull data for decoder. URL = \(url)")
        let (data, _) = try await URLSession.shared.data(from: url)
        print("inside getCharactersAPI & the data was pulled from the URL. about to decode")

        //LEADS TO PROBLEM CHILD
        //DELETE THIS AFTER PROBLEM CHILD ERR IS DEALT WITH
        do {
            let decodedJSON = try JSONDecoder().decode(APICharactersResponse.self, from: data)
            
            print("INSIDE GETCHARACTERSAPI & THE DECODER WORKED - DATA DECODED & ABOUT TO RETURN RESULTS.RESULTS TO ALLCHARACTERSVC'S CONFIGURECHARACTERS FUNC. FIRST RESULT = \(decodedJSON.results.first!)")
            return decodedJSON.results
            //.sorted(by: {$1.characterName > $0.characterName})

        } catch {
            print("ISSUE DECODING. ERROR = \(error)")
        }
    
        let decodedJSON = try JSONDecoder().decode(APICharactersResponse.self, from: data)
        
        print("INSIDE GETCHARACTERSAPI & THE DECODER WORKED - DATA DECODED & ABOUT TO RETURN RESULTS.RESULTS TO ALLCHARACTERSVC'S CONFIGURECHARACTERS FUNC. FIRST RESULT = \(decodedJSON.results.first!)")
        return decodedJSON.results
        
        
              
    }

}

