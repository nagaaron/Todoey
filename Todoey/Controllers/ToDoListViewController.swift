//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    lazy var realm = try! Realm()
    
    var choosenCategoryItems: Results<Item1>?
    
    var selectedCategory:Category1? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }
    
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return choosenCategoryItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierItem, for: indexPath)
        if let message = choosenCategoryItems?[indexPath.row] {
            cell.textLabel!.text = message.text
            cell.accessoryType = message.isChecked ? .checkmark : .none
        } else {
            cell.textLabel!.text = "No Items Added yet"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let myItem = choosenCategoryItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(myItem)
                    myItem.isChecked = !myItem.isChecked
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
    }
    //MARK: - Section to add a new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction( title: "AddItem", style: .default) {(action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item1()
                        newItem.text = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print(error)
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present (alert,animated: true, completion: nil)
        loadItems()
        
    }
    
    func saveToRealm(item: Item1) {
        do {
            try self.realm.write {
                realm.add(item)
            }
        }catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    
    func loadItems() {
        choosenCategoryItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
    }
}
//MARK: - SearchBar Methods

extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        choosenCategoryItems = choosenCategoryItems?.filter("text CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
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


//

