//
//  Move.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 07/09/22.
//

import Foundation

struct Move: Codable {
    let move: PokemonResource

    enum CodingKeys: String, CodingKey {
        case move
    }
}
