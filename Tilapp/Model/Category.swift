//
//  Category.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import Foundation

final class Category: Codable {
    var id: Int?
    var name: String
    
    init(name: String) {
        self.name = name
    }
}
