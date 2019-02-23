//
//  CategoriesTableVC.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class CategoriesTableVC: UITableViewController {

    var categories: [Category] = []
    
    let categoriesRequest = ResourceRequest<Category>(resourcePath: "categories")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        title = "Categories"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    func requestData(){
        // 1
        categoriesRequest.getAll { [weak self] result in
            // 2
            DispatchQueue.main.async {
                //sender?.endRefreshing()
            }
            switch result {
            // 3
            case .failure:
                let message = "There was an error getting the categories"
                //            ErrorPresenter.showError(message: message, on: self)
                print(message)
            // 4
            case .success(let categories):
                DispatchQueue.main.async { [weak self] in
                    self?.categories = categories
                    self?.tableView.reloadData()
                }
            }
        }
        
        /*
         Here’s what this does:
         1.Call getAll(completion:) to get all the categories. This returns a result in the completion closure.
         2.As the request is complete, call endRefreshing() on the refresh control.
         3.If the fetch fails, use the ErrorPresenter utility to display an alert view with an appropriate error message.
         4.If the fetch succeeds, update the categories array from the result and reload the table.
         */
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kCategoriesID", for: indexPath)

        let category = categories[indexPath.row]
        
        cell.textLabel?.text = category.name

        return cell
    }

}
