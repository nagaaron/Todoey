//
//  CategoryListViewController.swift
//  Todoey
//
//  Created by Aaron Nagel on 08.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//
import UIKit
import RealmSwift

class CategoryListViewController: UITableViewController{
    
    let realm = try! Realm()
    var categories: Results<Category>?
    override func viewDidLoad() {
        loadDataFromRealm()
        super.viewDidLoad()
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierCategory, for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // support function to execute segue
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories![indexPath.row]
        }
    }
    //MARK: - TableView Delegate Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction( title: "AddCategory", style: .default) {(action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.saveToRealm(category: newCategory)
        }
        alert.addTextField {(alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create new category"
        }
        alert.addAction(action)
        present (alert,animated: true, completion: nil)
        loadDataFromRealm()
    }
    
    func saveToRealm(category: Category) {
        do {
            try realm.write{
                realm.add(category)
            }
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
    
    func loadDataFromRealm () {
        self.categories = realm.objects(Category.self)
    }
    
    
    
}

