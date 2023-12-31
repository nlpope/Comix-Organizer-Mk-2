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
    //to be initialized w enums just after enum declarations
    var characterID: Int?
    //enum coding keys
    var characterName: String
    var characterAbbreviatedBio: String?
    var characterDetailedBio: String?
    //nested coding keys
    var characterThumbnailURL: URL
    var publisherID: Int?
    var publisherName: String?
    
    //for nested items: enum prop doesn't have to be declared up top
    //instead of decoding dictionary (impossible), just decode the final primitive type(s) & access outter "wrapper" using Enums

    //get it working, then rename "CharacterKey" singular = preferred, I thought
    //but docs use below (plural) for some reason
    enum CodingKeys: String, CodingKey {
        case id
        case characterName = "name"
        case characterAbbreviatedBio = "deck"
        case characterDetailedBio = "description"
        //below = nested
        case image
        case publisher
    }
    
    enum ImageKey: String, CodingKey {
        case characterThumbnailURL = "thumb_url"
    }
    
    enum PublisherKey: String, CodingKey {
        case publisherID = "id"
        case publisherName = "name"
    }
    
    //12.31 PROBLEM CHILD?
    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CharacterKey.self)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        characterID = try values.decode(Int.self, forKey: .id)
        
        characterName = try values.decode(String.self, forKey: .characterName)
        
        characterAbbreviatedBio = try values.decode(String.self, forKey: .characterAbbreviatedBio)
        
        characterDetailedBio = try values.decode(String.self, forKey: .characterDetailedBio)
        
        //link the 1st level key containing the nested container
        let imageNest = try values.nestedContainer(keyedBy: ImageKey.self, forKey: .image)
        let publisherNest = try values.nestedContainer(keyedBy: PublisherKey.self, forKey: .publisher)
        
        //then, reach into that nested container and decode the final vars you want
        characterThumbnailURL = try imageNest.decode(URL.self, forKey: .characterThumbnailURL)
        publisherID = try publisherNest.decode(Int.self, forKey: .publisherID)
        
        publisherName = try publisherNest.decode(String.self, forKey: .publisherName)
        
        

        
//        let dictionary: [String: Any] = try container.decode([String: Any].self, forKey: key)
    }
}

