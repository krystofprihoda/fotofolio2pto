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

struct Portfolio: Identifiable, Equatable {
    let id: UUID
    var authorUsername: String
    var name: String
    var photos: [IImage]
    var description: String
    var tags: [String]
    let timestamp: Date
    
    static func == (lhs: Portfolio, rhs: Portfolio) -> Bool {
        lhs.id == rhs.id && lhs.authorUsername == rhs.authorUsername
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
            id: UUID(),
            authorUsername: "vojtafoti",
            name: "Portréty",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!))
            ],
            description: "Baví mě zachycovat autentické okamžiky a pracovat s lidmi. Nafotím vám portréty, které dokonale zachytí vaši osobu a povahu!",
            tags: ["portrait", "people", "portrét", "lidé", "portret"],
            timestamp: Calendar.current.date(byAdding: .day, value: -5, to: Date())!
        )
    }

    static var dummyPortfolio2: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "ad.fotograf",
            name: "Lifestyle",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!))
            ],
            description: "I takovéhle lifestylové fotografie mohou být Vaše!",
            tags: ["person", "portrait", "lifestyle", "portret"],
            timestamp: Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        )
    }

    static var dummyPortfolio3: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "vojtafoti",
            name: "Svatby",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
            ],
            description: "Dojedu kamkoliv po republice a zachytím Váš speciální den.",
            tags: ["svatba", "svatby", "wedding"],
            timestamp: Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        )
    }

    static var dummyPortfolio4: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "karel__foti",
            name: "karlova architektura",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/dog")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!))
            ],
            description: "fotim skvele a nafotim cokoliv.",
            tags: ["interiér", "archi", "architektura", "reality", "exteriér"],
            timestamp: Calendar.current.date(byAdding: .day, value: -6, to: Date())!
        )
    }

    static var dummyPortfolio5: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "nejfotograf",
            name: "Svatby",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
            ],
            description: "Svatby jsou moje srdcovka, svěřte se do rukou profesionála.",
            tags: ["svatba", "svatby", "svatebnifotograf", "wedding"],
            timestamp: Calendar.current.date(byAdding: .day, value: 10, to: Date())!
        )
    }

    static var dummyPortfolio6: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "ad.fotograf",
            name: "Svatby",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/wedding")!))
            ],
            description: "Svatbám se věnuji dlouhodobě a postarám se o to, abych zachytil každý okamžik Vašeho speciálního dne.",
            tags: ["svatba", "svatby", "svatebnifotograf", "wedding"],
            timestamp: Calendar.current.date(byAdding: .day, value: 11, to: Date())!
        )
    }

    static var dummyPortfolio7: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "vojtafoti",
            name: "Architektura",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/architecture")!))
            ],
            description: "Dokonale zachytím interiér i exteriér Vaší lokace.",
            tags: ["interiér", "archi", "architektura", "reality", "exteriér"],
            timestamp: Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        )
    }
    
    static var dummyPortfolio8: Portfolio {
        Portfolio(
            id: UUID(),
            authorUsername: "portretyodmilana",
            name: "Portréty",
            photos: [
                IImage(src: .remote(URL(string: LOREMFLICKR + "/portrait")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/person")!)),
                IImage(src: .remote(URL(string: LOREMFLICKR + "/animal")!))
            ],
            description: "I takovéhle portréty můžou být Vaše!",
            tags: ["portrait", "people", "portrét", "lidé", "portret"],
            timestamp: Calendar.current.date(byAdding: .day, value: -3, to: Date())!
        )
    }

}
