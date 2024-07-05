//
//  APICaller.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

import UIKit

class APICaller {
    
    static let shared = APICaller()
    let baseURL       = "https://comicvine.gamespot.com/api"
    let cache         = NSCache<NSString, UIImage>()
    
    
    // see notes 12a & 12b in app delegate
    func getPublishers(page: Int) async throws -> [Publisher] {
        let endpoint        = "\(baseURL)/publishers/?api_key=\(NetworkCalls.API_KEY)&offset=\(page)&format=json&field_list=name,publisher,id,image,deck,birth,api_detail_url,aliases"
        
        guard let url       = URL(string: endpoint) else { throw COError.invalidURL }
        
        // see note 11 in app delegate
        let (data, _)       = try await URLSession.shared.data(from: url)
        let decoder         = JSONDecoder()
        let decodedJSON = try decoder.decode(APIPublishersResponse.self, from: data)
        
        return decodedJSON.results.sorted(by: {$1.name > $0.name})
    }

    
    // publisherTitles = volumes in API
    #warning("add page & url 'offset' param")
    func getPublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Title] {
        let endpoint = "\(publisherDetailsURL)?api_key=\(NetworkCalls.API_KEY)&format=json&field_list=volumes"
        guard let url = URL(string: endpoint) else { throw COError.invalidURL }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        #warning("consider removing the guard/let/and ? since above tupule accts for errors in data retrieval")
        guard let decodedJSON = try? JSONDecoder().decode(APITitlesResponse.self, from: data) else { throw COError.failedToGetData }
        
        return decodedJSON.results["volumes"]!.sorted(by: {$1.titleName > $0.titleName})
    }
    
    
    func getTitleIssues(withTitleDetailsURL titleDetailsURL: String) async throws -> [Issue] {
        guard let url = URL(string: "\(titleDetailsURL)?api_key=\(NetworkCalls.API_KEY)&format=json&field_list=issues") else {
            throw COError.invalidURL
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        //05.16 problem child
        //solved: I was expecting the "issues" url inst. of the "volume"
        //and accounted for the field_list that should've only incl. "issues" as a param
        let decodedJSON = try JSONDecoder().decode(APIIssuesResponse.self, from: data)
        print("json decoded")
        return decodedJSON.results["issues"]!.sorted(by: {$1.issueName > $0.issueName})
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        // see note 1 in app delegate
        guard let url = URL(string: urlString) else { return }
        
        // Network Call - where the image is downloaded
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                    completed(nil)
                    return
                  }
                    
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
    

}
