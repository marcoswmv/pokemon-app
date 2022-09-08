//
//  DetailViewModel.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 07/09/22.
//

import UIKit

final class DetailViewModel: Networking {

    let pokemonQueue = DispatchQueue(label: "CacheQueue")

    private let pokemonDispatchGroup: DispatchGroup = DispatchGroup()
    private let dispatchGroup: DispatchGroup = DispatchGroup()

    private let pokemonId: Int
    private var abilities: [String] = []
    private var moves: [String] = []

    var pokemon: Observable<Pokemon> = Observable(nil)
    let description: Observable<[(String, [String])]> = Observable(nil)
    var error: Observable<Error> = Observable(nil)

    init(pokemonId: Int) {
        self.pokemonId = pokemonId
    }

    deinit {
        print(self)
    }

    func fetchPokemon() {
        pokemonDispatchGroup.enter()
        requestPokemon(by: pokemonId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let pokemon):
                self.pokemon.value = pokemon
            case .failure(let error):
                self.error.value = error
            }
            self.pokemonDispatchGroup.leave()
        }

        pokemonDispatchGroup.notify(queue: .global(qos: .background)) {
            self.fetchPokemonsDescription()
        }
    }

    private func fetchPokemonsDescription() {
        guard let pokemon = pokemon.value else { return }

        fetchAbilities(for: pokemon)
        fetchMoves(for: pokemon)

        dispatchGroup.notify(queue: .main) {
            self.processDescription()
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
        guard let pokemon = pokemon.value else { return }
        
        let abilities: [String] = abilities.prefix(6).map { $0.replacingOccurrences(of: "\n", with: " ") }
        let types: [String] = pokemon.types.prefix(6).map { $0.type.name.capitalizingFirstLetter() }
        let moves: [String] = moves.prefix(6).map { $0.replacingOccurrences(of: "\n", with: " ") }

        let descriptionDict: [String: [String]] = [
            "Height": [pokemon.height.description],
            "Weight": [pokemon.weight.description],
            "Abilities": abilities,
            "Base experience": [pokemon.baseExperience.description],
            "Types": types,
            "Species": [pokemon.species.name.capitalizingFirstLetter()],
            "Moves": moves
        ]

        let test = descriptionDict
            .sorted(by: { $0.key < $1.key })
            .map { ($0, $1) }
        description.value = test
    }
}
