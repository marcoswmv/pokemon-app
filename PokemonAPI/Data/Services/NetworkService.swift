//
//  NetworkService.swift
//  PokemonAPI
//
//  Created by Marcos Vicente on 05/09/22.
//

import UIKit

typealias ErrorMessageHandlingBlock = ((String) -> Void)
typealias ImageRequestCompletionBlock = (Result<UIImage, Error>) -> Void
typealias PokemonResponseBlock = (Result<PokemonResponse, Error>) -> Void

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

protocol Networking { }

extension Networking {
    func requestProducts(url: URL?, _ completionHandler: @escaping PokemonResponseBlock) {
        NetworkService.shared.requestProducts(url: url, completionHandler)
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
    func requestProducts(url: URL?, _ completionHandler: @escaping PokemonResponseBlock) {
        guard let url = url else {
            completionHandler(.failure(NetworkResponse.badRequest))
            return
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
                        print("RESPONSE: \(String.init(data: data, encoding: .utf8))")
                        do {
                            let productsResponse = try JSONDecoder().decode(PokemonResponse.self, from: data)
                            completionHandler(.success(products))
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
