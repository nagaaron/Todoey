//
//  CategoryListViewController.swift
//  Todoey
//
//  Created by Aaron Nagel on 08.03.23.
//  Copyright © 2023 App Brewery. All rights reserved.
//
import UIKit
import CoreData

class CategoryListViewController: UITableViewController {
        

    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let category = categoryArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifierCategory, for: indexPath)
        cell.textLabel!.text = category.cat
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //saveCategory()
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
    }
    //MARK: - TableView Delegate Methods
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction( title: "AddCategory", style: .default) {(action) in
            let newCategory = Category(context: self.context)
            newCategory.cat = textField.text!
            self.categoryArray.append(newCategory)
            self.saveCategory()
        }
        alert.addTextField {(alertTextField) in
            textField = alertTextField
            textField.placeholder = "Create new category"
        }
        alert.addAction(action)
        present (alert,animated: true, completion: nil)
    }
    
    func saveCategory() {
            do {
                try context.save()
            } catch {
                print(error)
            }
            tableView.reloadData()
    }
        
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray  = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}

