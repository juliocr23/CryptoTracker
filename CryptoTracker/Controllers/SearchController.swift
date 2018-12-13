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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        self.tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = UIColor.flatBlue()
        
        if display.isEmpty {
            loadImages()
            SVProgressHUD.show()
            self.cryptoComp.downloadPrices(completion: {
                SVProgressHUD.dismiss()
                self.display = Cryptocurrency.list
                self.tableView.reloadData()
            })
        }
    }
    
    func loadImages(){
        do {
            let url:URL  = Bundle.main.url(forResource: "res/images", withExtension: "json")!
            let jsonData = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            let  icons      = try jsonDecoder.decode([Icon].self, from: jsonData)
            
            for value in icons {
                let crypto = Cryptocurrency(icon: value)
                Cryptocurrency.list.append(crypto)
            }
          
        }catch{
            print("Failed reading data")
            print(error)
        }
    }
    
    //MARK: table methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex =  indexPath.row
        
        if alertDelegate != nil {
           
            navigationController?.popViewController(animated: true)
            alertDelegate?.setAlert(crypto: display[selectedIndex])
        }else {
            performSegue(withIdentifier: "goToDetails", sender: self)
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

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToDetails" {
           let destinationVC = segue.destination as! graphController
            destinationVC.crypto = display[selectedIndex]
        }
    }
    
}
