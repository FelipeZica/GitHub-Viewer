//
//  DetailsViewModek.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 07/02/25.
//

import Foundation

protocol HomeViewModelProtocol{
    var repositories: [UserRepositories] { get set }
    var errorMessage: ErrorType? { get set }
    
    func fetchRepositoriesByUser(for user: String)
}

class HomeViewModel:HomeViewModelProtocol{
    //MARK: propriedades
    @Published var repositories: [UserRepositories] = []
    @Published var errorMessage: ErrorType?
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    
    //MARK: Método que chama a getRepositories da classe APIServices
    func fetchRepositoriesByUser(for user: String) {
        apiService.getRepositories(name: user) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let repositories):
                    self?.repositories = repositories ?? []
                case .failure(let error):
                    self?.errorMessage = error
                }
            }
        }
    }
}
