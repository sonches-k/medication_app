//
//  APIClientProtocol.swift
//  Tabletnica
//

import Foundation

protocol APIClientProtocol {
    func sendRequest<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    )
}
