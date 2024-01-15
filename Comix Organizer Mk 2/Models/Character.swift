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
    var characterID: Int
    //enum coding keys
    var characterName: String
    var characterAbbreviatedBio: String?
    var characterDetailedBio: String?
    //nested coding keys
    var characterThumbnailURL: URL?
    var publisherID: Int
    var publisherName: String
    
    //for nested items: enum prop doesn't have to be declared up top
    //instead of decoding dictionary (impossible), just decode the final primitive type(s) & access outter "wrapper" using Enums
    
    //(a) start w plural "CodingKeys" always...
    enum CodingKeys: String, CodingKey {
        case id
        case characterName = "name"
        case characterAbbreviatedBio = "deck"
        case characterDetailedBio = "description"
        //below = nested
        case image
        case publisher
    }
    
    //(a) then move to singular naming convention - docs
    enum ImageKey: String, CodingKey {
        case characterThumbnailURL = "thumb_url"
    }
    
    enum PublisherKey: String, CodingKey {
        case publisherID = "id"
        case publisherName = "name"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        characterID = try container.decode(Int.self, forKey: .id)
        
        characterName = try container.decode(String.self, forKey: .characterName)
        
        characterAbbreviatedBio = try container.decodeIfPresent(String.self, forKey: .characterAbbreviatedBio)
        
        characterDetailedBio = try container.decodeIfPresent(String.self, forKey: .characterDetailedBio)
        
        //link the 1st level key containing the nested container
        let imageNest = try container.nestedContainer(keyedBy: ImageKey.self, forKey: .image)
        let publisherNest = try container.nestedContainer(keyedBy: PublisherKey.self, forKey: .publisher)
        
        //then, reach into that nested container and decode the final vars you want
        characterThumbnailURL = try imageNest.decode(URL.self, forKey: .characterThumbnailURL)
        publisherID = try publisherNest.decode(Int.self, forKey: .publisherID)
        
        publisherName = try publisherNest.decode(String.self, forKey: .publisherName)
        
        //        print("""
        //              character name = \(characterName),
        //              \npublisher name = \(publisherName)
        //              \ncharacter deck = \(characterAbbreviatedBio!)
        //              """)
        
    }
}

