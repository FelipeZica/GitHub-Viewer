//
//  APIService.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 06/02/25.
//

import Foundation

protocol APIServiceProtocol {
    func getRepositories(name: String, completion: @escaping (Result<[UserRepositories]?, ErrorType>) -> Void)
}

//MARK: Classe responsavael pelas requisições da API
class APIService: APIServiceProtocol{
    
    //MARK: Sigletoon
    static let shared = APIService()
    private init() {}
    
    //FMARK: unção de chamada da API
    func getRepositories(name: String, completion: @escaping (Result<[UserRepositories]?, ErrorType>) -> Void) {
        let url = URL(string: "https://api.github.com/users/\(name)/repos")!
        URLSession.shared.dataTask(with: url) { data, response, erro in
            //MARK: Verifica se ocorreu algum erro de conexão
            if let erro = erro {
                completion(.failure(.networkError))
                return
            }
            //MARK: Verifica se os dados não são nulos
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            //MARK: verifica qual resposta foi retornada do servidor e se o usuário existe
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Success in get data.")
                } else{
                    completion(.failure(.userNotFound))
                }
            }
            //MARK: Reliza a decodificação do JSON
            if let repositories = self.decodeRepositories(from: data) {
                DispatchQueue.main.async {
                    completion(.success(repositories))
                }
            }
        }.resume()
    }
    //MARK: Função de decodificação do JSON
    private func decodeRepositories(from data: Data) -> [UserRepositories]? {
        let decoder = JSONDecoder()
        
        do {
            let repositories = try decoder.decode([UserRepositories].self, from: data)
            return repositories
        } catch {
            print("Erro na decodificação: \(error)")
            return nil
        }
    }
    
}
