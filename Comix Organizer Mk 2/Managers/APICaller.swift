//
//  APICaller.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

#warning("figure another way to present / dismiss the loading view - present AND dismiss @ call site in VC instead of dismiss @ the non-exist. completion?")
#warning("get rid of all the prints & comments > transfer to app delegate")

import Foundation

class APICaller {
    
    static let shared = APICaller()
    
    func getPublishersAPI() async throws -> [Publisher] {
        // see note _ in app delegate > only place baseURL is not passed from a click
        let endpoint        = "https://comicvine.gamespot.com/api/publishers/?api_key=\(NetworkCalls.API_KEY)&format=json&field_list=name,publisher,id,image,deck,birth,api_detail_url,aliases"
        
        guard let url       = URL(string: endpoint) else { throw COError.invalidURL }
        // see note _ in app delegate > async variant of urlsession - may suspend code, hence the await
        let (data, _)       = try await URLSession.shared.data(from: url)
        
        do {
            let decoder     = JSONDecoder()
            let decodedJSON = try decoder.decode(APIPublishersResponse.self, from: data)
            return decodedJSON.results.sorted(by: {$1.publisherName > $0.publisherName})

        } catch {
            throw COError.failedToGetData
        }
    }
    
  
    //publisherTitles = volumes in API
    func getPublisherTitlesAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Title] {
        let endpoint = "\(publisherDetailsURL)?api_key=\(NetworkCalls.API_KEY)&format=json&field_list=volumes"
        guard let url = URL(string: endpoint) else {
            throw APIError.invalidURL
        }
        print(url)

        let (data, _) = try await URLSession.shared.data(from: url)
        print("the data was pulled from the URL. about to decode")

        let decodedJSON = try JSONDecoder().decode(APITitlesResponse.self, from: data)
        
        print("json decoded")
        
        print("this publisher has \(decodedJSON.results["volumes"]!.count) titles")
         
        return decodedJSON.results["volumes"]!.sorted(by: {$1.titleName > $0.titleName})
    }
    
    //MARK: GET TITLE ISSUES
    func getTitleIssuesAPI(withTitleDetailsURL titleDetailsURL: String) async throws -> [Issue] {
        guard let url = URL(string: "\(titleDetailsURL)?api_key=\(Constants.API_KEY)&format=json&field_list=issues") else {
            throw APIError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        //05.16 problem child
        //solved: I was expecting the "issues" url inst. of the "volume"
        //and accounted for the field_list that should've only incl. "issues" as a param
        let decodedJSON = try JSONDecoder().decode(APIIssuesResponse.self, from: data)
        print("json decoded")
        return decodedJSON.results["issues"]!.sorted(by: {$1.issueName > $0.issueName})
    }
    
    //MARK: GET PUBLISHER CHARACTERS
    func getPublisherCharactersAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Character] {
        print("inside getPublisherCharactersAPI")
        
        guard let url = URL(string: "\(publisherDetailsURL)?api_key=\(Constants.API_KEY)&format=json&field_list=characters") else {
            throw APIError.invalidURL
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        print("the data was pulled from the URL. about to decode")
    
        let decodedJSON = try JSONDecoder().decode(APICharactersResponse.self, from: data)
        
        print("json decoded")
        
        return decodedJSON.results["characters"]!.sorted(by: {$1.characterName > $0.characterName})
              
    }

}


/**
 ARCHIVED CODE
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 func getPublisherCharactersAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> Dictionary<String, [Character]>
 
 --------------------------
 print("inside getCharactersAPI & the guard let threw no error. About to start URLSession to pull data for decoder. URL = \(url)")
 */
