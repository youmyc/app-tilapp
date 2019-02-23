//
//  CreateUserTableVC.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class CreateUserTableVC: UITableViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // 1
        guard let name = nameTextField.text,
            !name.isEmpty else {
                ErrorPresenter
                    .showError(message: "You must specify a name", on: self)
                return
        }
        
        // 2
        guard let username = usernameTextField.text,
            !username.isEmpty else {
                ErrorPresenter.showError(message: "You must specify a username", on: self)
                return
        }
        
        // 3
        let user = User(name: name, username: username)
        // 4
        ResourceRequest<User>(resourcePath: "users")
            .save(user) { [weak self] result in
            switch result {
            // 5
            case .failure:
            let message = "There was a problem saving the user"
            ErrorPresenter.showError(message: message, on: self)
            // 6
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.navigationController?
                    .dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
