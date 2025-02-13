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
    //MARK: Propriedades
    let viewModel = HomeViewModel()
    var cancellables = Set<AnyCancellable>()
    private var usernamer: String = ""
    
    //MARK: Componentes
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
        title = "GitHub Viewer"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        setupBindings()
        setupUIComponents()
    }
    
    //MARK: Método de organização dos componentes (Constraints) e adição na View
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
    //MARK: Método que valida o nome digitado e faz a requisição para a API atravéz da ViewModel
    @objc private func searchRepositories(_ sender: UIButton){
        usernameTextField.resignFirstResponder()
        guard !usernamer.isEmpty else{
            alert(title: "Alert", message: "Enter a valid username!")
            return
        }
        self.viewModel.fetchRepositoriesByUser(for: usernamer)
    }
    
    //MARK: Alerta personalizável para menssagens de erro
    func alert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    //MARK: Método que inicia o monitoramento das variáveis de erro e repositorios
    private func setupBindings() {
        //Gatilho da navegação
        viewModel.$repositories
            .sink { [weak self] repositories in
                if !repositories.isEmpty{
                    self?.navigateToDetails(repositories: repositories)
                }
            }
            .store(in: &cancellables)
        //Validador de erros
        viewModel.$errorMessage
            .compactMap { $0 }
            .sink { error in
                self.alert(title: "Error", message: error.rawValue)
            }
            .store(in: &cancellables)
    }
}
//MARK: Configurações do textfield do username, adiciona o texto digitado em uma variável e adiciona a função de fechar o teclado apertando o botão return, respectivamente
extension HomeViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.usernamer = textField.text ?? ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
//MARK: Implementação do delegate e navegação para view de detalhes
extension HomeViewController: DetailsViewControllerDelegate{
    private func navigateToDetails(repositories: [UserRepositories]) {
        let detailsVC = DetailsViewController()
        detailsVC.repositories = repositories
        detailsVC.delegate = self
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    //MARK: Remove as ferencias ao usuário anterior
    func didFinishViewingDetails() {
        self.usernamer = ""
        self.usernameTextField.text = ""
    }
}
