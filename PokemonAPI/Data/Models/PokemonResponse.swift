//
//  PokemonResponse.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

struct PokemonResponse: Codable {
    let count: Int
    let results: [PokemonResource]
}

struct PokemonResource: Codable {
    let name: String
    let url: String
}

