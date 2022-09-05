//
//  Pokemon.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

struct Pokemon: Codable {
    let id: Int
    let order: Int
    let name: String
    let height: Int
    let weight: Int
    let abilities: [Ability]
    let forms: [PokemonResource]
    let sprites: Sprite
    let types: [PokemonType]
    let species: PokemonResource

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case order = "order"
        case name = "name"
        case height = "height"
        case weight = "weight"
        case abilities = "abilities"
        case forms = "forms"
        case sprites = "sprites"
        case species = "species"
        case types = "types"
    }
}
