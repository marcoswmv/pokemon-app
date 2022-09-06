//
//  ListViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import Foundation

class ListViewModel: Networking {

    private let dispatchGroup: DispatchGroup = DispatchGroup()
    private var pokemonsResponse: PokemonResponse? = nil
    private var pokemons: [Pokemon] = []

    var items: Observable<[PokemonCellViewModel]> = Observable([])
    var error: Observable<Error?> = Observable(nil)

    init() { }

    deinit {
        print(self)
    }

    func fetch(for page: Int) {
        fetchPokemonsResourceList(page)
        fetchPokemons()

        dispatchGroup.notify(queue: .main) {
            self.pokemons.forEach { pokemon in
                guard let imageUrlString = pokemon.sprites.other?.officialArtwork.frontDefault else { return }
                let pokemonViewModel = PokemonCellViewModel(name: pokemon.name,
                                                            order: pokemon.order,
                                                            imageUrlString: imageUrlString)

                self.items.value?.append(pokemonViewModel)
            }
        }
    }

    private func fetchPokemonsResourceList(_ page: Int) {
        dispatchGroup.enter()
        requestPokemonsList(page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let pokemons):
                self.pokemonsResponse = pokemons
            case .failure(let error):
                self.error.value = error
            }
            self.dispatchGroup.leave()
        }
        dispatchGroup.wait()
    }

    private func fetchPokemons() {
        pokemonsResponse?.results.forEach({ resource in
            self.dispatchGroup.enter()

            requestPokemon(by: resource.url) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let pokemon):
                    self.pokemons.append(pokemon)
                case .failure(let error):
                    self.error.value = error
                }
                self.dispatchGroup.leave()
            }
        })
    }
}
