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
       
    var id: Int
    //testing enum coding keys
    var characterName: String
    var publisherID: Int
    var publisherName: String
    
    //enum prop doesn't have to be declared up top
    enum CodingKeys: String, CodingKey {
        case id
        case characterName = "name"
        case publisher
    }
    
    //instead of decoding dictionary (impossible), just decode the final primitive type(s) & access outter "wrapper" using Enums
    enum PublisherKeys: String, CodingKey {
        case publisherID = "id"
        case publisherName = "name"
    }
    
    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        
        characterName = try values.decode(String.self, forKey: .characterName)
        
        //link the 1st level key containing the nested container
        let publisherNest = try values.nestedContainer(keyedBy: PublisherKeys.self, forKey: .publisher)
        
        //then, reach into that nested container and decode the final vars you want
        publisherID = try publisherNest.decode(Int.self, forKey: .publisherID)
        
        publisherName = try publisherNest.decode(String.self, forKey: .publisherName)
        
        

        
//        let dictionary: [String: Any] = try container.decode([String: Any].self, forKey: key)
    }
}
