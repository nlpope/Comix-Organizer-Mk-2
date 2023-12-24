//
//  Character.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/20/23.
//

import Foundation

struct APICharactersResponse: Decodable {
    let results: [Character]
}


//changing to just Decodable
//Codable protocol throws error after new init
struct Character: Decodable {
       
    let id: Int
    let characterName: String
    let publisher: Dictionary<String, Any>
    
    enum CodingKeys: String, CodingKey {
        case id, publisher
        case characterName = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        let dictionary: [String: Any] = try container.decode([String: Any].self, forKey: key)
    }
}
