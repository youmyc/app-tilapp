//
//  SelectUserTableVC.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class SelectUserTableVC: UITableViewController {
    
    var users: [User] = []
    
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1
        let usersRequest =
            ResourceRequest<User>(resourcePath: "users")
        
        usersRequest.getAll { [weak self] result in
            switch result {
            // 2
            case .failure:
                let message = "There was an error getting the users"
                ErrorPresenter.showError(message: message,on: self) {
                    self?.navigationController?.popViewController(animated: true)
                }
            // 3
            case .success(let users):
                self?.users = users
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
            }
        }
        /*
         Here’s what this does:
         1.Get all the users from the API.
         2.If the request fails, show an error message. Return to the previous view once a user taps dismiss on the alert.
         3.If the request succeeds, save the users and reload the table data.
         */
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "kSelectUserID", for: indexPath)

        let user = users[indexPath.row]
        
        cell.textLabel?.text = user.name
        
        if user.name == selectedUser?.name {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let cell = tableView.cellForRow(at: indexPath)
        
        self.performSegue(withIdentifier: "UnwindSelectUserSegue", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        if segue.identifier == "UnwindSelectUserSegue" {
            // 2
            guard
//                let cell = sender as? UITableViewCell,
                let indexPath = sender as? IndexPath
                else {
                    return
            }
            // 3
            selectedUser = users[indexPath.row]
        }
        
        /*
         Here’s what this does:
         1.Verify this is the expected segue.
         2.Get the index path of the cell that triggered the segue.
         3.Update selectedUser to the user for the tapped cell.
         */
    }
}
