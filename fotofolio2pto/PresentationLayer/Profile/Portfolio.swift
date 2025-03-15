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

public struct Portfolio: Identifiable, Equatable {
    public let id: Int
    public var author: User
    public var name: String
    public var photos: [IImage]
    public var description: String
    public var tags: [String]
    public let timestamp: Date
    public var isFlagged: Bool
    
    init(
        id: Int,
        author: User,
        name: String,
        photos: [IImage],
        description: String,
        tags: [String],
        timestamp: Date,
        isFlagged: Bool = false
    ) {
        self.id = id
        self.author = author
        self.name = name
        self.photos = photos
        self.description = description
        self.tags = tags
        self.timestamp = timestamp
        self.isFlagged = isFlagged
    }
    
    public static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        lhs.id == rhs.id
    }
}

extension Portfolio {
    static let sampleData: [Portfolio] = [
        dummyPortfolio1,
        dummyPortfolio2,
        dummyPortfolio3,
        dummyPortfolio4,
        dummyPortfolio5,
        dummyPortfolio6,
        dummyPortfolio7,
        dummyPortfolio8
    ]
    
    static var dummyPortfolio1: Portfolio {
        Portfolio(
            id: 1,
            author: .dummy1,
            name: "Portréty",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!))
            ],
            description: "Baví mě zachycovat autentické okamžiky a pracovat s lidmi. Nafotím vám portréty, které dokonale zachytí vaši osobu a povahu!",
            tags: ["Portrét", "Rodina"],
            timestamp: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        )
    }

    static var dummyPortfolio2: Portfolio {
        Portfolio(
            id: 2,
            author: .dummy2,
            name: "Lifestyle",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!))
            ],
            description: "I takovéhle lifestylové fotografie mohou být Vaše!",
            tags: ["Portrét"],
            timestamp: Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        )
    }

    static var dummyPortfolio3: Portfolio {
        Portfolio(
            id: 3,
            author: .dummy1,
            name: "Svatby",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
            ],
            description: "Dojedu kamkoliv po republice a zachytím Váš speciální den.",
            tags: ["Svatba"],
            timestamp: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        )
    }

    static var dummyPortfolio4: Portfolio {
        Portfolio(
            id: 4,
            author: .dummy3,
            name: "karlova architektura",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/dog")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!))
            ],
            description: "fotim skvele a nafotim cokoliv.",
            tags: ["Interiér", "Exteriér", "Architektura"],
            timestamp: Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        )
    }

    static var dummyPortfolio5: Portfolio {
        Portfolio(
            id: 4,
            author: .dummy5,
            name: "Svatby",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
            ],
            description: "Svatby jsou moje srdcovka, svěřte se do rukou profesionála.",
            tags: ["Svatba"],
            timestamp: Calendar.current.date(byAdding: .day, value: 10, to: Date())!
        )
    }

    static var dummyPortfolio6: Portfolio {
        Portfolio(
            id: 5,
            author: .dummy2,
            name: "Svatby",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
            ],
            description: "Svatbám se věnuji dlouhodobě a postarám se o to, abych zachytil každý okamžik Vašeho speciálního dne.",
            tags: ["Svatba"],
            timestamp: Calendar.current.date(byAdding: .day, value: 11, to: Date())!
        )
    }

    static var dummyPortfolio7: Portfolio {
        Portfolio(
            id: 6,
            author: .dummy1,
            name: "Architektura",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!))
            ],
            description: "Dokonale zachytím interiér i exteriér Vaší lokace.",
            tags: ["Reality"],
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        )
    }
    
    static var dummyPortfolio8: Portfolio {
        Portfolio(
            id: 7,
            author: .dummy6,
            name: "Portréty",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!))
            ],
            description: "I takovéhle portréty můžou být Vaše!",
            tags: ["Portrét"],
            timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        )
    }

}
