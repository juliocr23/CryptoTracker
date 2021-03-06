//
//  TableViewController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 11/30/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit
import ChameleonFramework
import SVProgressHUD
import Alamofire
import SwiftyJSON


/*
 TODO: Fix contraints in category story board
 Also accessory type is not the color I want it
 */

protocol AlertProtocol {
    func setAlert(crypto: Cryptocurrency);
}


class SearchController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var display:[Cryptocurrency] = Cryptocurrency.list
    var cryptoComp: CryptoCompare = CryptoCompare()
    var selectedIndex = 0
    var isAlertController = false
    var alertDelegate:AlertProtocol?
    var graphSegue = "goToGraph"
    var lastUpdate: Date?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.flatBlue()
        
        if display.isEmpty {
            Cryptocurrency.loadImages()
            SVProgressHUD.show()
           CryptoCompare.downloadPrices(completion: {
                SVProgressHUD.dismiss()
                self.display = Cryptocurrency.list
                self.tableView.reloadData()
            
                self.lastUpdate = Date()
                self.updatePriceInBG()
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !display.isEmpty {
            print("View appear")
            display = Cryptocurrency.list
            tableView.reloadData()
        }
    }
    
   private func updatePriceInBG(){
        DispatchQueue.global(qos: .background).async {
            while true {
                let now = Date()
                
                //Update price every 5 minutes
                if  now.timeIntervalSinceNow - self.lastUpdate!.timeIntervalSinceNow > 300 {
                    
                    Cryptocurrency.list.removeAll(keepingCapacity: true)
                    Cryptocurrency.loadImages()
                    CryptoCompare.downloadPrices(completion: {
                        if self.searchBar.text!.isEmpty {
                            self.display = Cryptocurrency.list
                            self.tableView.reloadData()
                        }
                    })
                    self.lastUpdate = Date()
                }
            }
        }
    }
    //MARK: table methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex =  indexPath.row
        
        if alertDelegate != nil {
           
            navigationController?.popViewController(animated: true)
            alertDelegate?.setAlert(crypto: display[selectedIndex])
        }else {
            performSegue(withIdentifier: graphSegue, sender: self)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return display.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath)  as! SearchCell
        cell.setCrypto(crypto: display[indexPath.row])
        
        return cell
    }
    
    //MARK: SearchBar methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            display =  Cryptocurrency.list
        }
        else {
            
            //If searchText is equal than set it to display
            display =  Cryptocurrency.list.filter{($0.icon.name.lowercased() == searchText.lowercased())}
            
            //If there are no elements, get elements that cointain searchText
            if display.count <= 0 {
                display = Cryptocurrency.list.filter { ($0.icon.name.lowercased().contains(searchText.lowercased())) }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == graphSegue {
           let destinationVC = segue.destination as! graphController
            destinationVC.crypto = display[selectedIndex]
            
            searchBar.text = ""
            display = Cryptocurrency.list
            view.endEditing(true)
            tableView.reloadData()
        
        }
    }
    
}
