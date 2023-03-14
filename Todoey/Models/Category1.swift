//
//  Data.swift
//  Todoey
//
//  Created by Aaron Nagel on 10.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category1: Object {
    @Persisted var name: String = ""
    @Persisted var items = List<Item1>()
}