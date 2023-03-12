//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm()
    
    var choosenCategoryItems: Results<Item>?
    
    var selectedCategory:Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar.delegate = self
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
        let myItem = choosenCategoryItems![indexPath.row]
        updateRealm(item: myItem)
        
    }
    //MARK: - Section to add a new Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction( title: "AddItem", style: .default) {(action) in
            let newItem = Item()
            newItem.text = textField.text!
            self.saveToRealm(item: newItem)
        }
        alert.addTextField {(alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present (alert,animated: true, completion: nil)
        loadItems()
    }
    
    func saveToRealm(item: Item) {
        do {
            try self.realm.write {
                realm.add(item)
            }
        }catch {
            print(error)
        }
        tableView.reloadData()
   }
    
    
    // function load items from database with a default of loading all items
    func loadItems() {
        //let items = realm.objects(Item.self)
        self.choosenCategoryItems =  realm.objects(Item.self)

        //let items = realm.objects(Item.self)
        //self.choosenCategoryItems = items.where {
        //    $0.parentCategory == self.selectedCategory!
        //}
    }
    
    func updateRealm(item: Item) {
        let item = realm.objects(Item.self).first!
        do {
            try self.realm.write {
                item.isChecked = !item.isChecked
                }
            }catch {
                print(error)
            }
        tableView.reloadData()
        }
}
//MARK: - SearchBar Methods

//extension ToDoListViewController: UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //let request: NSFetchRequest<Item> = Item.fetchRequest()
//        //request.predicate = NSPredicate(format: "text CONTAINS[cd] %@", searchBar.text!)
//        //request.sortDescriptors = [NSSortDescriptor(key: "text", ascending: true)]
//        loadItems(with: request)
//    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}

//func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
//
//    let categoryPredicate = NSPredicate(format: "parentCategory.cat MATCHES %@", self.selectedCategory!.cat!)
//
//    if let additionalPredicate = predicate {
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
//    } else {
//        request.predicate = categoryPredicate
//    }
//
//    do {
//        itemArray  = try context.fetch(request)
//    } catch {
//        print(error)
//    }
//    tableView.reloadData()
//}

//

