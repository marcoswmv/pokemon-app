//
//  ListViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import Foundation

final class ListViewModel: Networking {

    private let dispatchGroup: DispatchGroup = DispatchGroup()

    private var currentPage: Int = 0

    private var pokemonsResponse: PokemonResponse? = nil
    private var pokemons: [Pokemon] = []

    var items: Observable<[PokemonCellViewModel]> = Observable([])
    var error: Observable<Error> = Observable(nil)
    var sorting: Observable<Bool> = Observable(false)

    init() { }

    deinit {
        print(self)
    }

    func fetchPokemonsList(for page: Int = 0, completionHandler: (() -> Void)? = nil) {
        requestPokemonsList(page: page) { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success(let pokemons):
                self.pokemonsResponse = pokemons
                self.fetchPokemonsData(completionHandler: completionHandler)
            case .failure(let error):
                self.error.value = error
            }
        }
    }

    private func fetchPokemonsData(completionHandler: (() -> Void)? = nil) {
        pokemonsResponse?.results.forEach({ resource in
            self.dispatchGroup.enter()

            requestPokemon(by: resource.url) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let pokemon):
                    if !self.pokemons.contains(where: { $0.id == pokemon.id }) {
                        self.pokemons.append(pokemon)
                    }
                case .failure(let error):
                    self.error.value = error
                }
                self.dispatchGroup.leave()
            }
        })

        dispatchGroup.notify(queue: .main) {
            var localPokemonViewModels: [PokemonCellViewModel] = []
            self.pokemons
                .sorted(by: { $0.order < $1.order })
                .forEach { pokemon in
                    guard let imageUrlString = pokemon.sprites.other?.officialArtwork.frontDefault,
                          let imageUrl = URL(string: imageUrlString) else { return }
                    let pokemonViewModel = PokemonCellViewModel(id: pokemon.id,
                                                                name: pokemon.name,
                                                                order: pokemon.order,
                                                                imageUrl: imageUrl) { isFavorite in
                        if isFavorite,
                           let pokemonData = try? JSONEncoder().encode(pokemon) {
                            self.uploadPokemon(urlString: Text.dummyAPI, bodyData: pokemonData) { result in
                                switch result {
                                case .success(let response):
                                    print(response)
                                case .failure(let error):
                                    self.error.value = error
                                }
                            }
                        }
                    }
                    if !localPokemonViewModels.contains(where: { $0.id == pokemonViewModel.id })  {
                        localPokemonViewModels.append(pokemonViewModel)
                    }
                }
            self.items.value = localPokemonViewModels
            completionHandler?()
        }
    }

    func sortList() {
        sorting.value?.toggle()
        items.value?.sort(by: { (sorting.value ?? false) ? $0 > $1 : $0 < $1 })
    }

    func paginateList() {
        let limit = 20
        let pageOffset = (currentPage + 1) * limit

        if pokemons.count >= pageOffset {
            currentPage += 1
        }

        fetchPokemonsList(for: pageOffset)
    }

    func getModel(by id: Int) -> Pokemon? {
        pokemons.first(where: { $0.id == id })
    }
}
