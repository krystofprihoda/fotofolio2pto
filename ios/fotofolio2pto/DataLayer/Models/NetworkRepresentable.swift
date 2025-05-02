//
//  NetworkRepresentable.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

protocol NetworkRepresentable {
    associatedtype NetworkModel
    var networkModel: NetworkModel { get }
}
