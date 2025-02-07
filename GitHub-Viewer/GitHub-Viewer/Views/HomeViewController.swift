//
//  HomeView.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 06/02/25.
//

import Foundation
import UIKit
import Combine

class HomeViewController:UIViewController{
    //Propriedades
    let viewModel = HomeViewModel()
    var cancellables = Set<AnyCancellable>()
    private var usernamer: String = ""
    
    //Componentes
    lazy private var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.delegate = self
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy private var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Search", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20)
        button.addTarget(self, action: #selector (searchRepositories(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        setupBindings()
        setupUIComponents()
    }
    
    //Função de organização dos componentes (Constraints) e adição na View
    private func setupUIComponents(){
        self.view.addSubview(usernameTextField)
        self.view.addSubview(searchButton)
        
        NSLayoutConstraint.activate([
            
            usernameTextField.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            usernameTextField.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            usernameTextField.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            searchButton.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 10),
            searchButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    //Função que verifica o nome digitado e faz a requisição para a API atravéz da ViewModel
    @objc private func searchRepositories(_ sender: UIButton){
        usernameTextField.resignFirstResponder()
        guard !usernamer.isEmpty else{
            alert(title: "Alert", message: "Enter a valid username!")
            return
        }
        self.viewModel.fetchRepositoriesByUser(for: usernamer)
    }
    
    //Alerta personalizável para menssagens de erro
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    //Função que inicia o monitoramento das variáveis de erro e repositorios
    private func setupBindings() {
        viewModel.$repositories
            .sink { repositories in
                //TODO: Navegação para a tela de detalhes
            }
            .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                self.alert(title: "Error", message: error.rawValue)
            }
            .store(in: &cancellables)
    }
}
//Configurações do textfield do username, adiciona o texto digitado em uma variável e adiciona a função de fechar o teclado apertando o botão return, respectivamente
extension HomeViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.usernamer = textField.text ?? ""
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//#Preview{
//    HomeView()
//}
