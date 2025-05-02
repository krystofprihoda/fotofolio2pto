//
//  DomainRepresentable.swift
//  fotofolio2pto
//
//  Created by Kryštof Příhoda on 02.05.2025.
//

protocol DomainRepresentable {
    associatedtype DomainModel
    var domainModel: DomainModel { get throws }
}
