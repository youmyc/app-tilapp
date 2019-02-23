//
//  AcronymsTableVC.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import UIKit

class AcronymsCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AcronymsTableVC: UITableViewController {
    
    // 1
    var acronyms: [Acronym] = []
    // 2
    let acronymsRequest = ResourceRequest<Acronym>(resourcePath: "acronyms")
    
    /*
     Here’s what this does:
     1.Declare an array of acronyms. These are the acronyms the table displays.
     2.Create a ResourceRequest for acronyms.
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        title = "Acronyms"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        requestData()
    }
    
    func requestData(){
        // 1
        acronymsRequest.getAll { [weak self] acronymResult in
            // 2
            DispatchQueue.main.async {
                // sender?.endRefreshing()
            }
            
            switch acronymResult {
            // 3
            case .failure:
                ErrorPresenter.showError(message:"There was an error getting the acronyms", on: self)
            // 4
            case .success(let acronyms):
                DispatchQueue.main.async { [weak self] in
                    self?.acronyms = acronyms
                    self?.tableView.reloadData()
                }
            }
        }
        
        /*
         Here’s what this does:
         1.Call getAll(completion:) to get all the acronyms. This returns a result in the completion closure.
         2.As the request is complete, call endRefreshing() on the refresh control.
         3.If the fetch fails, use the ErrorPresenter utility to display an alert view with an appropriate error message.
         4.If the fetch succeeds, update the acronyms array from the result and reload the table.
         */
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return acronyms.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kAcronymID", for: indexPath)

        let acronym = acronyms[indexPath.row]
        
        cell.textLabel?.text = acronym.short
        
        cell.detailTextLabel?.text = acronym.long

        return cell
    }

}
