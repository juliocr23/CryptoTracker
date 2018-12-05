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


class SearchController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var display:[Cryptocurrency] = Cryptocurrency.list
    var cryptoComp: CryptoCompare = CryptoCompare()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.flatBlue()
        
        print("In Search")
        if Cryptocurrency.list.isEmpty {
            SVProgressHUD.show()
            
            cryptoComp.downloadCryptos {
                self.loadImages()
                self.cryptoComp.downloadPrices(completion: {
                    
                    SVProgressHUD.dismiss()
                    self.display = Cryptocurrency.list
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    //MARK: table methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex =  indexPath.row
        performSegue(withIdentifier: "goToDetails", sender: self)
    }
    
    
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
    
    func loadImages(){
        
        if let imagesData = DBMS.getImages() {
            
            print("Loading images")
            var notFound = 0
            for i in 0..<imagesData.count {
                
                let result = binarySearch(crypto: Cryptocurrency.list,
                                          start: 0,
                                          end: Cryptocurrency.list.count,
                                          key: imagesData[i].id!)
                if result != -1 {
                    Cryptocurrency.list[result].imageData = imagesData[i]
                } else {
                    notFound += 1
                }
            }
            
            print("not found \(notFound)")
        } else {
            print("Data do not exist")
            return
        }
        
        Cryptocurrency.list =  Cryptocurrency.list.filter{ $0.imageData !=  nil }
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetails" {
           let destinationVC = segue.destination as! DetailController
            destinationVC.crypto = display[selectedIndex]
        }
    }
    
}
