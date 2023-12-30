//
//  Character.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/20/23.
//

import Foundation
import UIKit

struct APICharactersResponse: Decodable {
    let results: [Character]
}


//changing to just Decodable
//Codable protocol throws error after new init
struct Character: Decodable {
       
    var characterID: Int
    //enum coding keys
    var characterName: String
    var characterAbbreviatedBio: String
    var characterDetailedBio: String
    //below = nested
    var characterThumbnail: UIImageView
    var publisherID: Int
    var publisherName: String
    
    //for nested items: enum prop doesn't have to be declared up top
    //instead of decoding dictionary (impossible), just decode the final primitive type(s) & access outter "wrapper" using Enums

    enum CodingKeys: String, CodingKey {
        case id
        case characterName = "name"
        case characterAbbreviatedBio = "deck"
        case characterDetailedBio = "description"
        //below = nested
        case image
        case publisher
    }
    
    enum ImageKeys: String, CodingKey {
        case characterThumbnail = "thumb_url"
    }
    
    enum PublisherKeys: String, CodingKey {
        case publisherID = "id"
        case publisherName = "name"
    }
    
    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        characterID = try values.decode(Int.self, forKey: .id)
        
        characterName = try values.decode(String.self, forKey: .characterName)
        
        characterAbbreviatedBio = try values.decode(String.self, forKey: .characterAbbreviatedBio)
        
        characterDetailedBio = try values.decode(String.self, forKey: .characterDetailedBio)
        
        //link the 1st level key containing the nested container
        let imageNest = try values.nestedContainer(keyedBy: ImageKeys.self, forKey: .image)
        let publisherNest = try values.nestedContainer(keyedBy: PublisherKeys.self, forKey: .publisher)
        
        //then, reach into that nested container and decode the final vars you want
        characterThumbnail = try imageNest.decode(URL.self, forKey: .characterThumbnail)
        
        publisherID = try publisherNest.decode(Int.self, forKey: .publisherID)
        
        publisherName = try publisherNest.decode(String.self, forKey: .publisherName)
        
        

        
//        let dictionary: [String: Any] = try container.decode([String: Any].self, forKey: key)
    }
}
