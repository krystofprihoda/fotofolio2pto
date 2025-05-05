//
//  IImage.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

import Foundation
import UIKit

public struct IImage: Identifiable, Equatable {
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
}

public enum MyImageEnum {
    case remote(String)
    case local(UIImage)
}
