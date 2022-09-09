//
//  PokemonDetailViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 09/09/22.
//

import Foundation

struct PokemonDetailViewModel: Equatable {
    init(name: String = "", imageUrl: URL? = nil, description: [(String, [String])] = []) {
        self.name = name
        self.imageUrl = imageUrl
        self.description = description
    }

    let name: String
    let imageUrl: URL?
    let description: [(String, [String])]

    static func == (lhs: PokemonDetailViewModel, rhs: PokemonDetailViewModel) -> Bool {
        return lhs.name == rhs.name &&
        lhs.imageUrl == rhs.imageUrl
    }
}
