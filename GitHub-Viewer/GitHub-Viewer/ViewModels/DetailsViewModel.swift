//
//  DetailsViewModel.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 07/02/25.
//

import Foundation
protocol DetailsViewModelProtocol{
    var repositories: [UserRepositories] { get set }
    var errorMessage: ErrorType? { get set }
    
    func reloadData(user: String)
}

class DetailsViewModel:DetailsViewModelProtocol {
    //Propriedades
    @Published var repositories: [UserRepositories] = []
    @Published var errorMessage: ErrorType?
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }
    //Função que busca atualizações nos repositorios do usuário
    func reloadData(user: String){
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
