//
//  TableViewController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 11/30/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit
import ChameleonFramework

class SearchController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var display:[Cryptocurrency] = Cryptocurrency.list
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self
        self.tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.flatBlue()
    }

    
    //MARK: table methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)  as! SearchCell
        cell.setCrypto(crypto: display[indexPath.row])
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            display =  Cryptocurrency.list
        }
        else {
            
            //If searchText is equal than set it to display
            display =  Cryptocurrency.list.filter{($0.name.lowercased() == searchText.lowercased())}
            
            //If there are no elements, get elements that cointain searchText
            if display.count <= 0 {
                display = Cryptocurrency.list.filter { ($0.name.lowercased().contains(searchText.lowercased())) }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
