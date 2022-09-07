//
//  PokemonResponse.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

struct PokemonResponse: Codable, Equatable {
    let count: Int
    let results: [PokemonResource]

    static func == (lhs: PokemonResponse, rhs: PokemonResponse) -> Bool {
        return lhs.count == rhs.count &&
        lhs.results == rhs.results
    }
}

struct PokemonResource: Codable, Equatable {
    let name: String
    let url: String

    static func == (lhs: PokemonResource, rhs: PokemonResource) -> Bool {
        return lhs.name == rhs.name &&
        lhs.url == rhs.url
    }
}

