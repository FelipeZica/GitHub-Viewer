//
//  DetailsViewController.swift
//  GitHub-Viewer
//
//  Created by Luiz Felipe on 07/02/25.
//

import Foundation
import UIKit

protocol DetailsViewControllerDelegate: AnyObject {
    func didFinishViewingDetails()
}

class DetailsViewController: UIViewController {
    
    weak var delegate: DetailsViewControllerDelegate?
    var repositories: [UserRepositories] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        print(repositories)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.delegate?.didFinishViewingDetails()
    }

}
