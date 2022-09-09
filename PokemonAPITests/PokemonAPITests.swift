//
//  PokemonAPITests.swift
//  PokemonAPITests
//
//  Created by Marcos Vicente on 09/09/22.
//

import XCTest
@testable import PokemonAPI

class PokemonAPITests: XCTestCase {

    func testPokemonsListNotEmpty() {
        let expect = expectation(description: "Pokemons")
        let listViewModel = ListViewModel()
        var localPokemonCellViewModels: [PokemonCellViewModel] = []

        listViewModel.items.bind { pokemonCellViewModels in
            guard let pokemonCellViewModels = pokemonCellViewModels,
                  pokemonCellViewModels.count > 0 else { return }
            localPokemonCellViewModels.append(contentsOf: pokemonCellViewModels)
        }
        listViewModel.fetchPokemonsList(for: 0) {
            expect.fulfill()
        }

        waitForExpectations(timeout: 5.0)
        
        XCTAssertNotEqual(localPokemonCellViewModels, [])
    }

    func testPokemonsListEmpty() {
        let listViewModel = ListViewModel()
        var pokemonCellViewModels: [PokemonCellViewModel] = []

        listViewModel.items.bind { pokemons in
            guard let pokemons = pokemons else { return }
            pokemonCellViewModels.append(contentsOf: pokemons)
        }

        listViewModel.fetchPokemonsList()

        XCTAssertEqual(pokemonCellViewModels, [])
    }

    func testSuccessfullyGetModel() {
        let expect = expectation(description: "Pokemons")
        let listViewModel = ListViewModel()
        var pokemon: Pokemon? = nil

        listViewModel.fetchPokemonsList(for: 0) {
            if let pokemonCellViewModel = listViewModel.items.value?.first {
                pokemon = listViewModel.getModel(by: pokemonCellViewModel.id)
            }
            expect.fulfill()
        }

        waitForExpectations(timeout: 5.0)
        XCTAssertNotNil(pokemon)
    }

    func testFetchPokemonDetails() {
        let expect = expectation(description: "Pokemons")
        let detailViewModel = DetailViewModel(pokemonId: 3)
        var localPokemonDetailViewModel: PokemonDetailViewModel = PokemonDetailViewModel()

        detailViewModel.pokemonDetailViewModel.bind { pokemonDetailViewModel in
            guard let pokemonDetailViewModel = pokemonDetailViewModel else { return }
            localPokemonDetailViewModel = pokemonDetailViewModel
        }
        detailViewModel.fetchPokemon {
            expect.fulfill()
        }

        waitForExpectations(timeout: 5.0)

        XCTAssertNotEqual(localPokemonDetailViewModel, PokemonDetailViewModel())
    }
}
