//
//  Character.swift
//  Comix Organizer Mk 2
//
//  Created by Noah Pope on 12/20/23.
//

import Foundation
import UIKit

//PROBLEM CHILD
//GETTING TYPE MISMATCH DICTIONARY ERROR FOR RESULTS VAR IN APICHARACTERSRESPONSE
//got it, results in FAILING characters response followed by dict. {} while the WORKING publisher results are followed by array []
struct APICharactersResponse: Decodable {
    let results: Dictionary<String, [Character]>
}


//FORMER PROBLEM CHILD
//new 'publisher/pub-id' API Call didn't align w old vars, changed em to match
//instead of decoding dictionary (impossible), just decode the final, nested primitive type(s) & access outter "wrapper" using Enums
struct Character: Decodable {
    //nested coding keys
//    var characterDetailsURL: String
//    var characterID: Int
//    var characterName: String
        
    //(a) start w plural "CodingKeys" for top level enums & expected nest name cases...
    //for nested items: enum prop doesn't have to be declared up top
    enum CodingKeys: String, CodingKey {
        case results
//        case characters
    }
    
    //(b) then move to singular naming convention - docs
    enum ResultsKey: String, CodingKey {
        case characters
        //PROBLEM CHILD, LEFT OFF HERE 01.18.24
    }
    
    enum CharacterKey: String, CodingKey {
        case characterDetailsURL = "api_detail_url"
        case characterID = "id"
        case characterName = "name"
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
//        publisherDetailsURL = try container.decode(String.self, forKey: .publisherDetailsURL)
        
//        //(c) link the top level key containing the nested container using the corresp. top level case
//        let characterNest = try container.nestedContainer(keyedBy: CharacterKey.self, forKey: .characters)
//        
//        characterDetailsURL = try characterNest.decode(String.self, forKey: .characterDetailsURL)
//       
//        characterID = try characterNest.decode(Int.self, forKey: .characterID)
//        
//        characterName = try characterNest.decode(String.self, forKey: .characterName)
        
    }
    
}

struct CodableDictionary<Key : Hashable, Value : Codable> : Codable where Key : CodingKey {

    let decoded: [Key: Value]

    init(_ decoded: [Key: Value]) {
        self.decoded = decoded
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: Key.self)

        decoded = Dictionary(uniqueKeysWithValues:
            try container.allKeys.lazy.map {
                (key: $0, value: try container.decode(Value.self, forKey: $0))
            }
        )
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: Key.self)

        for (key, value) in decoded {
            try container.encode(value, forKey: key)
        }
    }
}












//OLD ENUM LAYERS & (IFPRESENT) DECODING FROM CONTAINER
//enum ImageKey: String, CodingKey {
//    case characterThumbnailURL = "thumb_url"
//}
//
//enum PublisherKey: String, CodingKey {
//    case publisherID = "id"
//    case publisherName = "name"
//}

//characterAbbreviatedBio = try container.decodeIfPresent(String.self, forKey: .characterAbbreviatedBio)
//
//characterDetailedBio = try container.decodeIfPresent(String.self, forKey: .characterDetailedBio)
//let imageNest = try container.nestedContainer(keyedBy: ImageKey.self, forKey: .image)
//let publisherNest = try container.nestedContainer(keyedBy: PublisherKey.self, forKey: .publisher)
