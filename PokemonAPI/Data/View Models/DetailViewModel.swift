//
//  DetailViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 07/09/22.
//

import UIKit

class DetailViewModel: Networking {

    private let pokemonId: Int

    var pokemon: Observable<Pokemon> = Observable(nil)
    var error: Observable<Error> = Observable(nil)

    init(pokemonId: Int) {
        self.pokemonId = pokemonId
    }

    func fetchPokemon() {
        requestPokemon(by: pokemonId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pokemon):
                self.pokemon.value = pokemon
            case .failure(let error):
                self.error.value = error
            }
        }
    }
}
