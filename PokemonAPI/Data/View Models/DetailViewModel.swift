//
//  DetailViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 07/09/22.
//

import UIKit

final class DetailViewModel: Networking {

    private let pokemonDispatchGroup: DispatchGroup = DispatchGroup()
    private let dispatchGroup: DispatchGroup = DispatchGroup()

    private let pokemonId: Int
    private var pokemon: Pokemon? = nil
    private var abilities: [String] = []
    private var moves: [String] = []

    var pokemonDetailViewModel: Observable<PokemonDetailViewModel> = Observable(nil)
    var error: Observable<Error> = Observable(nil)

    init(pokemonId: Int) {
        self.pokemonId = pokemonId
    }

    func fetchPokemon(completionHandler: (() -> Void)? = nil) {
        pokemonDispatchGroup.enter()
        requestPokemon(by: pokemonId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pokemon):
                self.pokemon = pokemon
            case .failure(let error):
                self.error.value = error
            }
            self.pokemonDispatchGroup.leave()
        }

        pokemonDispatchGroup.notify(queue: .global(qos: .background)) {
            self.fetchPokemonsDescription(completionHandler: completionHandler)
        }
    }

    private func fetchPokemonsDescription(completionHandler: (() -> Void)? = nil) {
        guard let pokemon = pokemon else { return }

        fetchAbilities(for: pokemon)
        fetchMoves(for: pokemon)

        dispatchGroup.notify(queue: .main) {
            self.processDescription()
            completionHandler?()
        }
    }

    private func fetchAbilities(for pokemon: Pokemon) {
        pokemon.abilities.forEach { resource in
            self.dispatchGroup.enter()
            self.requestDescription(by: resource.ability.url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let ability):
                    if let ability = ability.flavorTextEntries.first(where: { $0.language == .english }) {
                        self.abilities.append(ability.flavorText)
                    }
                case .failure(let error):
                    self.error.value = error
                }
                self.dispatchGroup.leave()
            }
        }
    }

    private func fetchMoves(for pokemon: Pokemon) {
        pokemon.moves.forEach { resource in
            self.dispatchGroup.enter()
            self.requestDescription(by: resource.move.url) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let moves):
                    if let move = moves.flavorTextEntries.first(where: { $0.language == .english }) {
                        self.moves.append(move.flavorText)
                    }
                case .failure(let error):
                    self.error.value = error
                }
                self.dispatchGroup.leave()
            }
        }
    }

    private func processDescription() {
        guard let pokemon = pokemon,
              let imageUrlString = pokemon.sprites.other?.officialArtwork.frontDefault else { return }
        
        let abilities: [String] = abilities.prefix(6).map { $0.replacingOccurrences(of: "\n", with: " ") }
        let types: [String] = pokemon.types.prefix(6).map { $0.type.name.capitalizingFirstLetter() }
        let moves: [String] = moves.prefix(6).map { $0.replacingOccurrences(of: "\n", with: " ") }

        let descriptionDict: [(String, [String])] = [
            ("Height", [pokemon.height.description]),
            ("Weight", [pokemon.weight.description]),
            ("Base experience", [pokemon.baseExperience.description]),
            ("Species", [pokemon.species.name.capitalizingFirstLetter()].sorted(by: { $0 < $1 })),
            ("Abilities", abilities.sorted(by: { $0 < $1 })),
            ("Types", types.sorted(by: { $0 < $1 })),
            ("Moves", moves.sorted(by: { $0 < $1 }))
        ]

        let resultDescription = descriptionDict.map { ($0, $1) }

        pokemonDetailViewModel.value = PokemonDetailViewModel(name: pokemon.name,
                                                  imageUrl: URL(string: imageUrlString),
                                                  description: resultDescription)
    }
}
