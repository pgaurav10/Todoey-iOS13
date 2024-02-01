//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import ChameleonFramework

class TodoViewController: SwipeTableViewController {

    let realm = try! Realm()
    var todoItems: Results<Item>?
    var category: Category? {
        didSet {
            print(category!.name)
            loadItems()
        }
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//    let defaults = UserDefaults.standard
    let dataPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        if let items = defaults.array(forKey: "Todo") as? [Item] {
//            itemArray = items
//        }

        searchBar.delegate = self
       
//        loadItems()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let navBar = navigationController?.navigationBar {
            
            navBar.backgroundColor = UIColor(hexString: category!.color)
            navBar.tintColor = ContrastColorOf(UIColor(hexString: category!.color)!, returnFlat: true)
            title = category!.name
            navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: navBar.tintColor!]
            searchBar.barTintColor = UIColor(hexString: category!.color)
        }
        
    }
    override func updateModel(at indexPath: IndexPath) {
        if let safeItem = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    realm.delete(safeItem)
                }
            } catch {
                print("Could not delete item: \(error.localizedDescription)")
            }
        }
    }
    //MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    @IBAction func addItemPress(_ sender: UIBarButtonItem) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Add Item", message: "Lets get it done!", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.placeholder = "Ex. Mango"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {(action) in
            if let textField = alert.textFields![0].text { // Force unwrapping because we know it exists.
                
                print("Text field: \(textField)")
                
                if let currentCategory = self.category {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField
                            newItem.date = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error")
                    }
                }
                
                
                
//                newItem.parentCategory = self.category
//                self.itemArray.append(newItem)
//                self.save(data: newItem)
//                self.defaults.set(self.itemArray, forKey: "Todo")
                self.tableView.reloadData()
            }
        }))

        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = todoItems?[indexPath.row].title
        
        
        
        if let safeCell = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = safeCell.title
            if safeCell.done == true {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            let color = UIColor(hexString: self.category!.color)!.darken(byPercentage: (CGFloat(indexPath.row) / CGFloat(todoItems!.count)))
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(color!, returnFlat: true)
            
            
        }
        return cell
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(todoItems?[indexPath.row] ?? nil)
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done = !item.done

                }
            } catch {
                print("Error while updating: \(error.localizedDescription)")
            }
        }
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//            todoItems[indexPath.row].done = false
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//            todoItems[indexPath.row].done = true
//        }
//        
////        context.delete(itemArray[indexPath.row])
//        save(data: todoItems[indexPath.row])
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
//    func save(data: Item) {
//        
//        do {
//            try realm.write {
//                realm.add(data)
//            }
//        } catch {
//            print("Error while saving")
//        }
//    }
    func loadItems() {
       
        todoItems = category?.items.sorted(byKeyPath: "date", ascending: true)
//        let pred = NSPredicate(format: "parentCategory.name Matches %@", category!.name!)
//        if let safePredicate = predicate {
//            request.predicate = NSCompoundPredicate(type: .and, subpredicates: [safePredicate, pred])
//        } else {
//            request.predicate = pred
//        }
        
        
        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error while fetching data: \(error)")
//        }
        
        tableView.reloadData()
        //        if let data = try? Data(contentsOf: dataPath!) {
        //            let decoder = PropertyListDecoder()
        //            do {
        //                itemArray = try decoder.decode([Item].self, from: data)
        //            } catch {
        //                print("Error decoding data")
        //            }
        //        }
    }
}

extension TodoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        print(searchBar.text!)
//        
//        request.predicate = predicate
//        
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//        
//        loadItems(with: request, predicate: predicate)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
//            let request: NSFetchRequest<Item> = Item.fetchRequest()
//            
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//            print(searchBar.text!)
//            
////            request.predicate = predicate
//            
//            
//            request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//            
//            loadItems(with: request, predicate: predicate)
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "date", ascending: true)
            
            tableView.reloadData()
        }
    }
}
