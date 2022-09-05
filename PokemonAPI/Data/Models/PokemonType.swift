//
//  PokemonType.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

struct PokemonType: Codable {
    let slot: Int
    let type: PokemonResource

    enum CodingKeys: String, CodingKey {
        case slot = "slot"
        case type = "type"
    }
}

