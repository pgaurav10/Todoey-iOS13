//
//  Item.swift
//  Todoey
//
//  Created by Gaurav Patil on 1/29/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item : Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var date: Date?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
