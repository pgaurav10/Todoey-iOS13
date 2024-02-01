//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by Gaurav Patil on 1/30/24.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self

        
        return cell
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            
            self.updateModel(at: indexPath)
            
//            if let safeCategory = self.categoryArray?[indexPath.row] {
//                do {
//                    try self.realm.write {
//                        self.realm.delete(safeCategory)
////                        self.tableView.reloadData()
//                    }
//                } catch {
//                    print("Could not delete category: \(error.localizedDescription)")
//                }
//                
//            }
            
        }

        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-Icon")

        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
//        options.transitionStyle = .border
        return options
    }
    
    func updateModel(at: IndexPath) {
        
    }
}
