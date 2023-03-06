//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Watch Ben Francis Video", "Buy Stocks for Matilda", "Clean Up Folder Structure"]
    
    // defaults store defined data when your app closes
    // only use small amounts of data as defaults are prone for hacking
    // UserDefaults.standard is a singleton -> there is only one defaults across all classes and objects
    let defaults = UserDefaults.standard
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {
            itemArray = items
        }
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        itemArray.count
    }
    
    // ? function does not need to be called as Object gets updated through implementation?
    // function gets called for every message in message.count from function above
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = itemArray[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        
        cell.textLabel!.text = message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // unselects the clicked cell after 0.2 msecs
        tableView.deselectRow(at: indexPath, animated: true)
    }
//MARK: - Section to add a new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // defines new alert variable
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        
        // defines a new action variable
        let action = UIAlertAction( title: "AddItem", style: .default) {(action) in
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray,forKey: "ToDoListArray")
            self.tableView.reloadData()
            
        }
        
        // adds a text field to the alert variable
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        // adds action to alert
        alert.addAction(action)
        
        // presents the alert on screen
        present (alert,animated: true, completion: nil)
        
    }
}

