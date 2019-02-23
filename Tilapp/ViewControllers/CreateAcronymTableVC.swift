//
//  CreateAcronymTableVC.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class CreateAcronymTableVC: UITableViewController {
    
    var selectedUser: User?

    @IBOutlet weak var acronymShortTextField: UITextField!
    @IBOutlet weak var acronymLongTextField: UITextField!
    @IBOutlet weak var userLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        populateUsers()
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        // 1
        guard
            let shortText = acronymShortTextField.text,
            !shortText.isEmpty else {
                ErrorPresenter.showError(message: "You must specify an acronym!",
                               on: self)
                return
        }
        
        guard
            let longText = acronymLongTextField.text,
            !longText.isEmpty else {
                ErrorPresenter.showError(message: "You must specify a meaning!",
                               on: self)
                return
        }
        
        guard let userID = selectedUser?.id else {
            let message = "You must have a user to create an acronym!"
            ErrorPresenter.showError(message: message, on: self)
            return
        }
        
        // 2
        let acronym = Acronym(short: shortText,
                              long: longText,
                              userID: userID)
        // 3
        ResourceRequest<Acronym>(resourcePath: "acronyms").save(acronym) { [weak self] result in
            switch result {
            // 4
            case .failure:
                let message = "There was a problem saving the acronym"
                ErrorPresenter.showError(message: message, on: self)
            // 5
            case .success:
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        /*
         Here are the steps to save the acronym:
         1.Ensure the user has filled in the acronym and meaning. Check the selected user is not nil and the user has a valid ID.
         2.Create a new Acronym from the supplied data.
         3.Create a ResourceRequest for an acronym and call save(_:).
         4.If the save request fails, show an error message.
         5.If the save request succeeds, return to the previous view: the acronyms table.
         */
    }
    
    func populateUsers() {
        // 1
        let usersRequest =
            ResourceRequest<User>(resourcePath: "users")
        
        usersRequest.getAll { [weak self] result in
            switch result {
            // 2
            case .failure:
                let message = "There was an error getting the users"
                ErrorPresenter.showError(message: message, on: self, {
                    self?.navigationController?.popViewController(animated: true)
                })
            // 3
            case .success(let users):
                DispatchQueue.main.async { [weak self] in
//                    self?.userLabel.text = users[0].name
                }
//                self?.selectedUser = users[0]
            }
        }
        
        /*
         Here’s what this does:
         1.Get all users from the API.
         2.Show an error if the request fails. Return from the create acronym view when the user dismisses the alert view. This uses the dismissAction on showError(message:on:dismissAction:).
         3.If the request succeeds, set the user field to the first user’s name and update selectedUser.
         */
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 2 {
            performSegue(withIdentifier: "SelectUserSegue", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 1
        if segue.identifier == "SelectUserSegue" {
            // 2
            guard
                let destination = segue.destination as? SelectUserTableVC,
                let user = selectedUser else {
                    return
            }
            // 3
            destination.selectedUser = user
        }
        
        /*
         Here’s what this does:
         1.Verify this is the expected segue.
         2.Get the destination from the segue and ensure a user has been selected.
         3.Set the selected user on SelectUserTableViewController.
         */
    }
    
    @IBAction  func updateSelectedUser(_ segue:UIStoryboardSegue){
        // 1
        guard let controller =
            segue.source as? SelectUserTableVC else {
                return
        }
        // 2
        selectedUser = controller.selectedUser
        userLabel.text = selectedUser?.name
        
        /*
         Here’s what this does:
         1.Ensure the segue came from SelectUserTableViewController.
         2.Update selectedUser with the new value and update the user label.
         */
    }
}
