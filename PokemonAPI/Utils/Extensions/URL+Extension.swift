//
//  URL+Extension.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else { return }
        urlComponents.queryItems = [URLQueryItem(name: name, value: value)]
        self = urlComponents.url!
    }
}
