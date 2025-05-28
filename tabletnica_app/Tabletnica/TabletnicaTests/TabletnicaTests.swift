//
//  TabletnicaTests.swift
//  TabletnicaTests
//
//  Created by Соня on 21.05.2025.
//

import XCTest
@testable import Tabletnica

final class MockAPIClientTests: XCTestCase {
    var client: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        client = MockAPIClient()
    }
    
    func testSignInMock() {
        let request = URLRequest(url: URL(string: "https://api.tabletnica.local/auth/sign_in")!)
        let exp = expectation(description: "signIn")
        
        client.sendRequest(request) { (result: Result<LoginResponse, Error>) in
            switch result {
            case .success(let resp):
                XCTAssertEqual(resp.token, "mock_jwt_token_123")
            case .failure:
                XCTFail("Expected success")
            }
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1.0)
    }
}

