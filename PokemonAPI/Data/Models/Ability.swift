//
//  Ability.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

struct AbilityResource: Codable {
    let ability: PokemonResource
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct Ability: Codable {
    let flavorTextEntries: [FlavorTextEntry]

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Language

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language = "language"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        flavorText = try values.decode(String.self, forKey: .flavorText)
        language = Language(rawValue: (try values.decode(PokemonResource.self, forKey: .language)).name) ?? .english
    }
}


enum Language: String, Codable {
    case english = "en"
    case french = "fr"
    case spanish = "es"
    case italian = "it"
}
