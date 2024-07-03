//
//  APICaller.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 11/7/23.
//

#warning("get rid of all the prints & comments > transfer to app delegate")

import UIKit

class APICaller {
    
    static let shared = APICaller()
    let cache         = NSCache<NSString, UIImage>()
    
    func getPublishersAPI() async throws -> [Publisher] {
        // see note _ in app delegate > only place baseURL is not passed from a click
        let endpoint        = "https://comicvine.gamespot.com/api/publishers/?api_key=\(NetworkCalls.API_KEY)&format=json&field_list=name,publisher,id,image,deck,birth,api_detail_url,aliases"
        
        guard let url       = URL(string: endpoint) else { throw COError.invalidURL }
        // see note _ in app delegate > async variant of urlsession - may suspend code, hence the await
        let (data, _)       = try await URLSession.shared.data(from: url)
        
        do {
            let decoder     = JSONDecoder()
            let decodedJSON = try decoder.decode(APIPublishersResponse.self, from: data)
            return decodedJSON.results.sorted(by: {$1.name > $0.name})

        } catch {
            throw COError.failedToGetData
        }
    }
    
  
    //publisherTitles = volumes in API
    func getPublisherTitlesAPI(withPublisherDetailsURL publisherDetailsURL: String) async throws -> [Title] {
        let endpoint = "\(publisherDetailsURL)?api_key=\(NetworkCalls.API_KEY)&format=json&field_list=volumes"
        guard let url = URL(string: endpoint) else {
            throw COError.invalidURL
        }
        print(url)

        let (data, _) = try await URLSession.shared.data(from: url)
        print("the data was pulled from the URL. about to decode")

        let decodedJSON = try JSONDecoder().decode(APITitlesResponse.self, from: data)
        
        print("json decoded")
        
        print("this publisher has \(decodedJSON.results["volumes"]!.count) titles")
         
        return decodedJSON.results["volumes"]!.sorted(by: {$1.titleName > $0.titleName})
    }
    
    
    func getTitleIssuesAPI(withTitleDetailsURL titleDetailsURL: String) async throws -> [Issue] {
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
