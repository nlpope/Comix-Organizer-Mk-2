//
//  Character.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/20/23.
//

import Foundation
import UIKit

struct APICharactersResponse: Decodable {
    //Dictionary shorthand
    let results: [String: [Character]]
    
  
}

struct Character: Decodable {
    var characterDetailsURL: String
    var characterID: Int
    var characterName: String
        
    
    enum CodingKeys: String, CodingKey {
//        case results (make ResultsKey enum)
        case characterDetailsURL = "api_detail_url"
        case characterID = "id"
        case characterName = "name"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)

        characterDetailsURL = try container.decode(String.self, forKey: .characterDetailsURL)
       
        characterID = try container.decode(Int.self, forKey: .characterID)
        
        characterName = try container.decode(String.self, forKey: .characterName)
        
    }
}



/**
 ARCHIVED CODE
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 OLD ENUM LAYERS & (IFPRESENT) DECODING FROM CONTAINER
 enum ImageKey: String, CodingKey {
     case characterThumbnailURL = "thumb_url"
 }
 
 enum PublisherKey: String, CodingKey {
     case publisherID = "id"
     case publisherName = "name"
 }

 characterAbbreviatedBio = try container.decodeIfPresent(String.self, forKey: .characterAbbreviatedBio)
 
 characterDetailedBio = try container.decodeIfPresent(String.self, forKey: .characterDetailedBio)
 let imageNest = try container.nestedContainer(keyedBy: ImageKey.self, forKey: .image)
 let publisherNest = try container.nestedContainer(keyedBy: PublisherKey.self, forKey: .publisher)
 
 */


