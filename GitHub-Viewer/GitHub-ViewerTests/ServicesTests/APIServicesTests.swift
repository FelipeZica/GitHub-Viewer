//
//  APIServicesTests.swift
//  GitHub-ViewerTests
//
//  Created by Luiz Felipe on 07/02/25.
//

import XCTest

@testable import GitHub_Viewer

final class APIServicesTests: XCTestCase {

    //MARK: Testa se a requisição com nome de usuário valido retorna os respositórios
    func testGetUserRepositiesSuccess() {
        let apiService = MockAPIService()
        let userName = "User1"
        
        apiService.getRepositories(name: userName, completion: { result in
           switch result {
           case let .success(repositories):
               XCTAssertTrue(repositories != nil)
               XCTAssertEqual(repositories?.count, 3)
           case .failure:
           XCTFail("Test Fail")
            }
        })
    }
    
    //MARK: Testa se ocorre erros de conexão
    func testNetworkError() {
        let apiService = MockAPIService(networkConexion: false)
        let userName = "User1"
        
        apiService.getRepositories(name: userName) { result in
            switch result {
                case .success:
                XCTFail("Test Fail")
            case let .failure(error):
                XCTAssertTrue(error == .networkError)
            }
        }
        
    }
    
    //MARK: Testa se um usuário não é encontrado
    func testUserNotFoundError() {
        let apiService = MockAPIService()
        let userName = "User4"
        
        apiService.getRepositories(name: userName) { result in
            switch result {
            case .success:
                XCTFail("Test Fail")
            case let .failure(error):
                XCTAssertTrue(error == .userNotFound)
            }
        }
    }
}

struct MockAPIService: APIServiceProtocol {
    //MARK: Dados fictícios para o teste
    private let testUserRepositiesData: [UserRepositories]? = [
        UserRepositories(name: "Prect Test 1", language: "Swift", owner: UserRepositories.Owner(login: "User1", avatar_url: "")),
        UserRepositories(name: "Prect Test 1", language: "Swift", owner: UserRepositories.Owner(login: "User1", avatar_url: "")),
        UserRepositories(name: "Prect Test 1", language: "Swift", owner: UserRepositories.Owner(login: "User1", avatar_url: "")),
        UserRepositories(name: "Prect Test 2", language: "Swift", owner: UserRepositories.Owner(login: "User2", avatar_url: "")),
        UserRepositories(name: "Prect Test 3", language: "Swift", owner: UserRepositories.Owner(login: "User3", avatar_url: ""))]
    var networkConexion: Bool = true
    func getRepositories(name: String, completion: @escaping (Result<[GitHub_Viewer.UserRepositories]?, GitHub_Viewer.ErrorType>) -> Void) {
        guard (testUserRepositiesData != nil) else {
            return
        }
        
        if ((testUserRepositiesData!.contains(where: { $0.owner.login == name })) && networkConexion){
            completion(.success(testUserRepositiesData?.filter({$0.owner.login == name })))
        }else{
            if !networkConexion{
                completion(.failure(.networkError))
            }else if name.isEmpty{
                completion(.failure(.dataNotFound))
            }else{
                completion(.failure(.userNotFound))
            }
        }
    }
    
    
}
