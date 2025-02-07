//
//  CustomTableViewCell.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 07/02/25.
//

import Foundation
import UIKit

//MARK: Célula personalizada para a TableView
class CustomTableViewCell: UITableViewCell {
    
    //MARK: Componentes da célula
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let lenguageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 0 
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Método de organização dos componentes (Constraints)
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(lenguageLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            lenguageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            lenguageLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            lenguageLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            lenguageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    //MARK: Método para configurar a célula com os dados
    func configure(with repository: UserRepositories) {
        titleLabel.text = repository.name
        lenguageLabel.text = repository.language
    }
}
