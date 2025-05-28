//
//  MockAPIClient.swift
//  Tabletnica
//

import Foundation

enum MockError: Error {
    case noMock
    case invalidData
}

final class MockAPIClient: APIClientProtocol {
    func sendRequest<T: Decodable>(
        _ request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
            guard let path = request.url?.path else {
                completion(.failure(MockError.noMock))
                return
            }
            
            switch path {
            case let p where p.contains("/auth/sign_in"):
                let json = """
                { "token": "mock_jwt_token_123" }
                """
                self.decodeMock(json: json, completion: completion)
                
            case let p where p.contains("/auth/sign_up"):
                let json = """
                { "id": 42 }
                """
                self.decodeMock(json: json, completion: completion)
                
            default:
                completion(.failure(MockError.noMock))
            }
        }
    }
    
    private func decodeMock<T: Decodable>(
        json: String,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let data = json.data(using: .utf8) else {
            completion(.failure(MockError.invalidData))
            return
        }
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            completion(.success(model))
        } catch {
            completion(.failure(error))
        }
    }
}
