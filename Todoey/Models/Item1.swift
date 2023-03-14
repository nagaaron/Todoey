//
//  Item.swift
//  Todoey
//
//  Created by Aaron Nagel on 10.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item1: Object {
    @Persisted var text: String
    @Persisted var isChecked: Bool
    @Persisted var dateCreated: Date
    
    var parentCategory = LinkingObjects(fromType: Category1.self, property: "items")
}
