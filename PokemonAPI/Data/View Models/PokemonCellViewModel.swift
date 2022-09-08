//
//  PokemonCellViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import Foundation

struct PokemonCellViewModel: Comparable {
    static func == (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: Int
    let name: String
    let order: Int
    let imageUrl: URL

    var handleFavoriteSetting: ((Bool) -> Void)

    static func < (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.order < rhs.order
    }

    static func > (lhs: PokemonCellViewModel, rhs: PokemonCellViewModel) -> Bool {
        lhs.order > rhs.order
    }
}
