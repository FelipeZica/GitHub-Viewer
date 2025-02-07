//
//  UserRepositories.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 06/02/25.
//

import Foundation

//Modelo de objeto que recebe as informações do Json
struct UserRepositories:Codable{
    let name: String
    let language: String?
    let owner: Owner
    
    struct Owner: Codable {
        let login: String
        let avatar_url: String
    }
}
