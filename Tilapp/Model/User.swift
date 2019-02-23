//
//  User.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import Foundation

final class User: Codable {
    var id: UUID?
    var name: String
    var username: String
    
    init(name: String, username: String) {
        self.name = name
        self.username = username
    }
}
