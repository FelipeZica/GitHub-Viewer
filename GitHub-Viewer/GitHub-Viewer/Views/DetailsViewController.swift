//
//  DetailsViewController.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 07/02/25.
//

import Foundation
import UIKit

//MARK: Delegate
protocol DetailsViewControllerDelegate: AnyObject {
    func didFinishViewingDetails()
}

class DetailsViewController: UIViewController {
    //MARK: Propriedades
    weak var delegate: DetailsViewControllerDelegate?
    var repositories: [UserRepositories] = []
    private var viewModel = DetailsViewModel()
    
    //MARK: Componentes
    lazy private var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy private var repositoriesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        return tableView
    }()
    
    private let refreshControl = UIRefreshControl()
    
    //MARK: Ciclo de vida da View
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
        
    }
    override func viewWillAppear(_ animated: Bool){
        uploadComponentsData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.didFinishViewingDetails()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
    }
    
    //MARK: Método de organização dos componentes (Constraints) e adição na View
    private func setupUI() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(repositoriesTableView)
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        repositoriesTableView.refreshControl = refreshControl
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.25),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),
            
            usernameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            usernameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            repositoriesTableView.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10),
            repositoriesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            repositoriesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            repositoriesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: Método que carrega os dados da API na View
    private func uploadComponentsData(){
        profileImageView.loadImage(from: String(repositories.first!.owner.avatar_url))
        usernameLabel.text = repositories.first!.owner.login
        repositoriesTableView.reloadData()
        
    }
    //MARK: Método que atualiza os repositórios
    @objc private func refreshData(){
        self.refreshControl.endRefreshing()
        viewModel.reloadData(user: self.repositories.first!.name)
        repositoriesTableView.reloadData()
        
    }
    
}
//MARK: Definições da TableView
extension DetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: repositories[indexPath.row])
        return cell
    }
    
    
}
//MARK: Extensão para carregar imagens da internet atravéz da URL
extension UIImageView {
    func loadImage(from url: String) {
        guard let imageUrl = URL(string: url) else { return }
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            }
        }.resume()
    }
}

