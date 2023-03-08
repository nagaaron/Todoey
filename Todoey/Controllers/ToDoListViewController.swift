//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: . documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // sets a new Items.plist on local sandbox
    
    
    // defaults store defined data when your app closes
    // only use small amounts of data as defaults are prone for hacking
    // UserDefaults.standard is a singleton -> there is only one defaults across all classes and objects
    // UserDefauls doesn't support self made Data Types
    //          let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // ? function does not need to be called as Object gets updated through implementation?
    // function gets called for every message in message.count from function above
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
        cell.textLabel!.text = message.text
        //Ternary Operator if checked then uncheck, if unchecked then check
        cell.accessoryType = message.isChecked ? .checkmark : .none
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //delete items per click
        //context.delete(itemArray[indexPath.row])
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
        saveItems()
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
            
            
            let newItem = Item(context: self.context)
            newItem.text = textField.text
            newItem.isChecked = false
            self.itemArray.append(newItem)
            self.saveItems()
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
    // function to encode
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    // function load items from database with a default of loading all items
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray  = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}
//MARK: - SearchBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
        loadItems(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
}

