//
//  Portfolio.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 21.06.2024.
//

import Foundation
import SwiftUI

// Move
let LOREMFLICKR = "https://loremflickr.com/1000/1000/"

public struct Portfolio: Identifiable, Equatable, Codable {
    public let id: String
    public let creatorId: String
    public let authorUsername: String
    public let name: String
    public let photos: [IImage]
    public let description: String
    public let category: [String]
    public let timestamp: Date
    
    enum CodingKeys: String, CodingKey {
        case id, creatorId, authorUsername, name, photos, description, category, timestamp
    }
    
    public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            creatorId = try container.decode(String.self, forKey: .creatorId)
            name = try container.decode(String.self, forKey: .name)
            authorUsername = try container.decode(String.self, forKey: .authorUsername)
            
            // Special handling for photos
            let photoURLs = try container.decode([String].self, forKey: .photos)
            photos = photoURLs.compactMap { urlString in
                if let url = URL(string: urlString) {
                    return IImage(src: .remote(url))
                }
                return nil
            }
            
            description = try container.decode(String.self, forKey: .description)
            category = try container.decode([String].self, forKey: .category)
        
            let timeInterval = try container.decode(Double.self, forKey: .timestamp)
            timestamp = Date(timeIntervalSince1970: timeInterval)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(creatorId, forKey: .creatorId)
            try container.encode(authorUsername, forKey: .authorUsername)
            try container.encode(name, forKey: .name)
            
            // Convert photos to URL strings
            let photoURLs = photos.compactMap { image in
                switch image.src {
                case .remote(let url):
                    return url.absoluteString
                case .local:
                    return nil
                }
            }
            try container.encode(photoURLs, forKey: .photos)
            
            try container.encode(description, forKey: .description)
            try container.encode(category, forKey: .category)
            
            try container.encode(timestamp.timeIntervalSince1970, forKey: .timestamp)
        }
    
    public init(
        id: String,
        creatorId: String,
        authorUsername: String,
        name: String,
        photos: [IImage],
        description: String,
        category: [String],
        timestamp: Date
    ) {
        self.id = id
        self.creatorId = creatorId
        self.authorUsername = authorUsername
        self.name = name
        self.photos = photos
        self.description = description
        self.category = category
        self.timestamp = timestamp
    }
    
    public static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        lhs.id == rhs.id
    }
}

//extension Portfolio {
//    static let sampleData: [Portfolio] = [
//        dummyPortfolio1,
//        dummyPortfolio2,
//        dummyPortfolio3,
//        dummyPortfolio4,
//        dummyPortfolio5,
//        dummyPortfolio6,
//        dummyPortfolio7,
//        dummyPortfolio8
//    ]
//    
//    static var dummyPortfolio1: Portfolio {
//        Portfolio(
//            id: 1,
//            author: .dummy1,
//            creator: .dummy1,
//            name: "Portréty",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!))
//            ],
//            description: "Baví mě zachycovat autentické okamžiky a pracovat s lidmi. Nafotím vám portréty, které dokonale zachytí vaši osobu a povahu!",
//            category: ["Portrét", "Rodina"],
//            timestamp: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
//        )
//    }
//
//    static var dummyPortfolio2: Portfolio {
//        Portfolio(
//            id: 2,
//            author: .dummy2,
//            creator: .dummy2,
//            name: "Lifestyle",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!))
//            ],
//            description: "I takovéhle lifestylové fotografie mohou být Vaše!",
//            category: ["Portrét"],
//            timestamp: Calendar.current.date(byAdding: .day, value: 3, to: Date())!
//        )
//    }
//
//    static var dummyPortfolio3: Portfolio {
//        Portfolio(
//            id: 3,
//            author: .dummy1,
//            creator: .dummy3,
//            name: "Svatby",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
//            ],
//            description: "Dojedu kamkoliv po republice a zachytím Váš speciální den.",
//            category: ["Svatba"],
//            timestamp: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
//        )
//    }
//
//    static var dummyPortfolio4: Portfolio {
//        Portfolio(
//            id: 4,
//            author: .dummy3,
//            creator: .dummy4,
//            name: "karlova architektura",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/dog")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!))
//            ],
//            description: "fotim skvele a nafotim cokoliv.",
//            category: ["Interiér", "Exteriér", "Architektura"],
//            timestamp: Calendar.current.date(byAdding: .day, value: -6, to: Date())!
//        )
//    }
//
//    static var dummyPortfolio5: Portfolio {
//        Portfolio(
//            id: 5,
//            author: .dummy5,
//            creator: .dummy5,
//            name: "Svatby",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
//            ],
//            description: "Svatby jsou moje srdcovka, svěřte se do rukou profesionála.",
//            category: ["Svatba"],
//            timestamp: Calendar.current.date(byAdding: .day, value: 10, to: Date())!
//        )
//    }
//
//    static var dummyPortfolio6: Portfolio {
//        Portfolio(
//            id: 6,
//            author: .dummy2,
//            creator: .dummy3,
//            name: "Svatby",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
//            ],
//            description: "Svatbám se věnuji dlouhodobě a postarám se o to, abych zachytil každý okamžik Vašeho speciálního dne.",
//            category: ["Svatba"],
//            timestamp: Calendar.current.date(byAdding: .day, value: 11, to: Date())!
//        )
//    }
//
//    static var dummyPortfolio7: Portfolio {
//        Portfolio(
//            id: 7,
//            author: .dummy1,
//            creator: .dummy4,
//            name: "Architektura",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!))
//            ],
//            description: "Dokonale zachytím interiér i exteriér Vaší lokace.",
//            category: ["Reality"],
//            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
//        )
//    }
//    
//    static var dummyPortfolio8: Portfolio {
//        Portfolio(
//            id: 8,
//            author: .dummy6,
//            creator: .dummy2,
//            name: "Portréty",
//            photos: [
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
//                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!))
//            ],
//            description: "I takovéhle portréty můžou být Vaše!",
//            category: ["Portrét"],
//            timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date())!
//        )
//    }
//
//}
