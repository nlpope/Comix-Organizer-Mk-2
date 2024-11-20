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
    
    
    func getAllPublishers(page: Int) async throws -> [Publisher]
    {
        let endpoint            = "\(baseURL)/publishers/?api_key=\(NetworkCallKeys.API_KEY)&offset=\(page)&format=json&field_list=name,publisher,id,image,deck,birth,api_detail_url,aliases"
        
        guard let url           = URL(string: endpoint) else { throw COError.invalidURL }
        
        let (data, _)           = try await URLSession.shared.data(from: url)
        let decoder             = JSONDecoder()
        guard let decodedJSON   = try? decoder.decode(APIPublishersResponse.self, from: data) else { throw COError.failedToGetData }
        
        return decodedJSON.results.sorted(by: {$1.name > $0.name})
    }
    
    
    func getFilteredPublishers(withName name: String, page: Int) async throws -> [Publisher]
    {
        let endpoint                = "\(baseURL)/publishers/?api_key=\(NetworkCallKeys.API_KEY)&filter=name:\(name)&offset=\(page)&format=json&field_list=name,publisher,id,image,deck,birth,api_detail_url,aliases"
        
        guard let url               = URL(string: endpoint) else { throw COError.invalidURL }
        
        let (data, _)               = try await URLSession.shared.data(from: url)
        let decoder                 = JSONDecoder()
        guard let decodedJSON       = try? decoder.decode(APIPublishersResponse.self, from: data) else { throw COError.failedToGetData }
        
        return decodedJSON.results.sorted(by: {$1.name > $0.name})
    }

    
    func getPublisherTitles(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Title]
    {
        let endpoint            = "\(publisherDetailsURL)?api_key=\(NetworkCallKeys.API_KEY)&format=json&field_list=volumes"
        guard let url           = URL(string: endpoint) else { throw COError.invalidURL }
                
        let (data, _)           = try await URLSession.shared.data(from: url)
        let decoder             = JSONDecoder()
        guard let decodedJSON   = try? decoder.decode(APITitlesResponse.self, from: data) else { throw COError.failedToGetData }
        
        return decodedJSON.results["volumes"]!.sorted(by: {$1.name > $0.name})
    }
    
    
    func getTitleIssues(withTitleDetailsURL titleDetailsURL: String) async throws -> [Issue]
    {
        let endpoint            = "\(titleDetailsURL)?api_key=\(NetworkCallKeys.API_KEY)&format=json&field_list=issues"
        guard let url           = URL(string: endpoint) else { throw COError.invalidURL }
        
        let (data, _)           = try await URLSession.shared.data(from: url)
        let decoder             = JSONDecoder()
        guard let decodedJSON   = try? decoder.decode(APIIssuesResponse.self, from: data) else { throw COError.failedToGetData }
        
        return decodedJSON.results["issues"]!.sorted(by: {$1.name > $0.name})
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void)
    {
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
                    
            #warning("fix below error")
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        task.resume()
    }
}
