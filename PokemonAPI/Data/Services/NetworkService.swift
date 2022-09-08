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

    func requestPokemon(by id: Int, _ completionHandler: @escaping PokemonResponseBlock) {
        NetworkService.shared.request(endpoint: "\(id)", completionHandler)
    }

    func requestPokemon(by urlString: String, _ completionHandler: @escaping PokemonResponseBlock) {
        NetworkService.shared.request(urlString: urlString, completionHandler)
    }

    func requestDescription(by urlString: String, _ completionHandler: @escaping DescriptionResponseBlock) {
        NetworkService.shared.request(urlString: urlString, completionHandler)
    }

    func uploadPokemon(urlString: String? = nil, bodyData: Data? = nil, _ completionHandler: @escaping PokemonResponseBlock) {
        NetworkService.shared.request(urlString: urlString, bodyData: bodyData, method: .post, completionHandler)
    }
}

final private class NetworkService {

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
    func request<T: Codable>(page: Int? = nil,
                             urlString: String? = nil,
                             endpoint: String? = nil,
                             bodyData: Data? = nil,
                             method: RequestMethod = .get,
                             _ completionHandler: @escaping (Result<T, Error>) -> Void) {
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

        var urlRequest = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.httpBody = bodyData

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
            guard let `self` = self else { return }
            self.handleResponse(with: data, response, error, completionHandler)
        }
        task.resume()
    }

    private func handleResponse<T: Codable>(with data: Data?, _ response: URLResponse?, _ error: Error?, _ completionHandler: @escaping (Result<T, Error>) -> Void) {
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

enum AppError: Error {
    case unableToDecode
}

private enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
}
