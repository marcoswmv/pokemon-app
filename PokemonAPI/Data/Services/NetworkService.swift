//
//  NetworkService.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit

protocol Networking { }

extension Networking {
    func requestPokemonsList(page: Int, _ completionHandler: @escaping PokemonsListResponseBlock) {
        NetworkService.shared.request(page: page, completionHandler)
    }

    func requestPokemon(by urlString: String, _ completionHandler: @escaping PokemonResponseBlock) {
        NetworkService.shared.request(urlString: urlString, completionHandler)
    }

    func requestPokemon(by id: Int, _ completionHandler: @escaping PokemonResponseBlock) {
        NetworkService.shared.request(endpoint: "\(id)", completionHandler)
    }
}

private class NetworkService {

    static let shared = NetworkService()

    private init() { }

    private func handleNetworkResponse(_ response: HTTPURLResponse) -> NetworkResult<Error> {
        switch response.statusCode {
        case 200...299 : return .success
        case 501...599 : return .failure(NetworkResponse.badRequest)
        case 600 : return .failure(NetworkResponse.outdated)
        default: return .failure(NetworkResponse.failed)
        }
    }
}

extension NetworkService {
    func request<T: Codable>(page: Int? = nil, urlString: String? = nil, endpoint: String? = nil, _ completionHandler: @escaping (Result<T, Error>) -> Void) {
        
        var url: URL? = nil

        if let urlString = urlString {
            url = URL(string: urlString)
        } else {
            url = URL(string: Text.pokemonsListUrlString)
        }

        guard var url = url else { return }

        if let endpoint = endpoint {
            url.appendPathComponent(endpoint)
        }

        if let page = page {
            url.appendQueryItem(name: "offset", value: page.description)
        }

        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                completionHandler(.failure(error))
            }

            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)

                switch result {
                case .success:
                    if let data = data {
                        do {
                            let responseData = try JSONDecoder().decode(T.self, from: data)
                            completionHandler(.success(responseData))
                        } catch {
                            completionHandler(.failure(NetworkResponse.unableToDecode(description: error.localizedDescription)))
                        }
                    }
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
}

private enum NetworkResult<Error> {
    case success
    case failure(Error)
}

private enum NetworkResponse: Error {
    case success
    case badRequest
    case outdated
    case failed
    case unableToDecode(description: String)
}
