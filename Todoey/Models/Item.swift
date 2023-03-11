//
//  Item.swift
//  Todoey
//
//  Created by Aaron Nagel on 10.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var text: String
    @Persisted var isChecked: Bool
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
