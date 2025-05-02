//
//  IImage.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation
import UIKit

public struct IImage: Identifiable, Equatable, Codable {
    public static func == (lhs: IImage, rhs: IImage) -> Bool {
        lhs.id == rhs.id
    }
    
    public let id = UUID()
    public let src: MyImageEnum
    
    enum CodingKeys: String, CodingKey {
        case id, src
    }
    
    public init(src: MyImageEnum) {
        self.src = src
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // For server responses, we'll always get a string URL
        let urlString = try container.decode(String.self, forKey: .src)
        self.src = .remote(urlString)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        switch src {
        case .remote(let url):
            try container.encode(url, forKey: .src)
        case .local:
            // When sending to server, we can't encode local images
            throw EncodingError.invalidValue(
                src,
                EncodingError.Context(
                    codingPath: encoder.codingPath,
                    debugDescription: "Cannot encode local images to server"
                )
            )
        }
    }
}

public enum MyImageEnum {
    case remote(String)
    case local(UIImage)
}
