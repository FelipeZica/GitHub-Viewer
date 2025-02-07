//
//  ErrorCases.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 07/02/25.
//

import Foundation

//MARK: Enum de erros personalizado
enum ErrorType: String, Error{
    case networkError = "A network error has occurred. Check your Internet connection and try again later."
    case userNotFound = "User not found. Please enter another name"
    case dataNotFound
}
