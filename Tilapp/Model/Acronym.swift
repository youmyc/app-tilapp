//
//  Acronym.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import Foundation

final class Acronym: Codable {
    var id: Int?
    var short: String
    var long: String
    var userID: UUID
    
    init(short: String, long: String, userID: UUID) {
        self.short = short
        self.long = long
        self.userID = userID
    }
}
