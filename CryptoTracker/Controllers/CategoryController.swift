//
//  AlertDetailController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/7/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit



/*
 TODO:
 background thread to request for price for those priceAlert
 Need to learn how to send notification
 and how to allow the app to run in the background
 Missing view for when user click on save alert
 
 */
class CategoryController: UITableViewController,AlertProtocol,PopupProtocol {
    
    //var crypto: Cryptocurrency?
    var display: [Cryptocurrency]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.flatBlueColorDark()
        
        display = Cryptocurrency.list.filter({ (crypto) -> Bool in
            return !crypto.alerts.isEmpty
        })
        
        if !display.isEmpty {
            tableView.separatorStyle  = .singleLine
            tableView.tableFooterView = UIView()
        } else {
            tableView.separatorStyle  = .none
        }
        
         display.sort(by:{$0.icon.symbol < $1.icon.symbol})
    }
    
    //MARK: Protocol methods
    func setAlert(crypto: Cryptocurrency) {
        
        let storyBrd   = UIStoryboard(name: "Popup", bundle: nil)
        let popup      = storyBrd.instantiateInitialViewController()! as! PopupController
        popup.crypto   = crypto
        popup.delegate = self
        
        present(popup, animated: true)
    }
    
    //MARK: Table methods
    //--------------------------------------------------------------------------------------\\
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return display.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertCell", for: indexPath)  as! categoryCell
        cell.setAlert(crypto: display[indexPath.row])
        
        return cell
    }
   
    @IBAction func AddAlert(_ sender: Any) {
        performSegue(withIdentifier: "goFromAlertToSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goFromAlertToSearch" {
            let destinationVC = segue.destination as! SearchController
            destinationVC.alertDelegate = self
        }
    }
    
    func complete(crypto: Cryptocurrency) {
        
        let result = binarySearch(crypto: display, start: 0, end: display.count, key: crypto.icon.symbol)
        
        if result == -1 {
            display.append(crypto)
        }
        
        display.sort(by:{$0.icon.symbol < $1.icon.symbol})
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
