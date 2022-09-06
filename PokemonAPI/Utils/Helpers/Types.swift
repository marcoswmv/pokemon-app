//
//  Types.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 06/09/22.
//

import UIKit

typealias PokemonsListResponseBlock = (Result<PokemonResponse, Error>) -> Void
typealias PokemonResponseBlock = (Result<Pokemon, Error>) -> Void
