//
//  CategoryViewControllerTableViewController.swift
//  Todoey
//
//  Created by Gaurav Patil on 1/29/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
//import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var categoryArray: Results<Category>?
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else {
            fatalError("Navigation controller does not exist")
        }
        
        navBar.backgroundColor = FlatBlue()
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Item", message: "Lets get it done!", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Ex. Grocery"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            if let textField = alert.textFields![0].text { // Force unwrapping because we know it exists.
                
                print("Text field: \(textField)")
                
                
                let newItem = Category()
                newItem.name = textField
                newItem.color = UIColor.randomFlat().hexValue()
//                self.categoryArray.append(newItem)
                self.save(data: newItem)
//                self.defaults.set(self.itemArray, forKey: "Todo")
                self.tableView.reloadData()
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    func save(data: Category) {
        
        do {
            try realm.write {
                realm.add(data)
            }
        } catch {
            print("Error while saving")
        }
    }
    
    func loadData() {
           
        categoryArray = realm.objects(Category.self)
//            do {
//                categoryArray = try context.fetch(request)
//            } catch {
//                print("Error while fetching data: \(error)")
//            }
            
        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let safeCategory = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(safeCategory)
//                        self.tableView.reloadData()
                }
            } catch {
                print("Could not delete category: \(error.localizedDescription)")
            }
            
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray?.count ?? 1
    }
      
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! SwipeTableViewCell
//        cell.delegate = self
//        return cell
//    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
//        cell.delegate = self

        // Configure the cell...
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No categories added"
        
        if let safeColor = categoryArray?[indexPath.row].color {
            cell.backgroundColor = UIColor(hexString: safeColor)
        } else {
            cell.backgroundColor = UIColor.randomFlat()
            categoryArray?[indexPath.row].color = (cell.backgroundColor?.hexValue())!
            
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
        }
        
        return cell
    }

    //MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.category = categoryArray?[indexPath.row]
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

