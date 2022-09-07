//
//  PokemonCellViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import Foundation

struct PokemonCellViewModel: Comparable {

    let id: Int
    let name: String
    let order: Int
    let imageUrl: URL

    static func < (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.order < rhs.order
    }

    static func > (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.order > rhs.order
    }
}
