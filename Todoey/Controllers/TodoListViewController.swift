//
//  ViewController.swift
//  Todoey
//
//  Created by Admin on 09/04/2019.
//  Copyright © 2019 Brain Plow. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  
  var selectedCategory : Category? {
    didSet{
      loadItems()
    }
    
  }
  
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    loadItems()
    tableView.dataSource = self
    
  }
  
  //MARK: Table View DataSource Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return itemArray.count
    
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell" , for: indexPath)
    let item = itemArray[indexPath.row]
    cell.textLabel?.text = item.title
    cell.accessoryType = item.done ? .checkmark : .none
    return cell
    
  }
  
  //MARK: Table View Delegate Methods
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
    itemArray[indexPath.row].done = !itemArray[indexPath.row].done
    //      context.delete(itemArray[indexPath.row])
    //      itemArray.remove(at: indexPath.row)
    
    saveItems()
    
    tableView.deselectRow(at: indexPath, animated: true)
    
  }
  
  //MARK: Add new itmes
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
      // What will happen when user click the add item button on our UILAertAction
      
      let newItem = Item(context: self.context)
      newItem.title = textField.text!
      newItem.done = false
      newItem.parentCategory = self.selectedCategory
      self.itemArray.append(newItem)
      self.saveItems()
      
    }
    
    alert.addTextField { (addTextField) in
      
      addTextField.placeholder = "Create New Item"
      print(addTextField.text as Any)
      textField = addTextField
      
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK - Model Manipulation Methods
  
  func saveItems(){
    
    do {
      try context.save()
    } catch {
      print(error)
    }
    self.tableView.reloadData()
  }
  
  func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
    
    let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
    
    if let additionalPredicate = predicate {
      
      request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
      
    } else {
      request.predicate = categoryPredicate
    }

    do {
      itemArray = try context.fetch(request)
    } catch {
      print(error)
    }
    tableView.reloadData()
  }
  
}

//MARK: - Search Bar Methods

extension TodoListViewController: UISearchBarDelegate{
  
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
    let request : NSFetchRequest<Item> = Item.fetchRequest()
    
    let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
    
    request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
    
    loadItems(with: request, predicate: predicate)
    
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
