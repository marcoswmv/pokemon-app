//
//  URL+Extension.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import Foundation

extension URL {

    mutating func appendQueryItem(name: String, value: String?) {

        guard var urlComponents = URLComponents(string: absoluteString),
              var queryItems = urlComponents.queryItems else { return }

        let queryItem = URLQueryItem(name: name, value: value)

        queryItems.append(queryItem)
        urlComponents.queryItems = queryItems
        
        self = urlComponents.url!
    }
}
