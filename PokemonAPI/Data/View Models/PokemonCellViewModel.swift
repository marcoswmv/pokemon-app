//
//  PokemonCellViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import Foundation

struct PokemonCellViewModel: Comparable {

    let name: String
    let order: Int
    let imageUrlString: String

    static func < (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.order < rhs.order
    }

    static func > (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.order > rhs.order
    }
}
