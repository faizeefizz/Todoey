//
//  ViewController.swift
//  Todoey
//
//  Created by Admin on 09/04/2019.
//  Copyright © 2019 Brain Plow. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
  
  var itemArray = [Item]()
  let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
  
  override func viewDidLoad() {
    super.viewDidLoad()

    loadItems()
    
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
    
    saveItems()

    tableView.deselectRow(at: indexPath, animated: true)

  }
  
  //MARK: Add new itmes
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
  
    let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
   
    let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
      
      // What will happen when user click the add item button on our UILAertAction
      
      let newItem = Item()
    
      newItem.title = textField.text!
      
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
    
    let encoder = PropertyListEncoder()
    
    do {
      let data = try encoder.encode(itemArray)
      try data.write(to: dataFilePath!)
    } catch {
      print(error)
    }
    self.tableView.reloadData()
    
  }
  
  func loadItems() {
    
    if let data = try? Data(contentsOf: dataFilePath!){
      let decoder = PropertyListDecoder()
      
      do {
      itemArray = try decoder.decode([Item].self, from: data)
      } catch{
        print(error)
      }
      
    }
    
  }
  
}

