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
    
    
    var display: [Cryptocurrency]!
    var segueToAssets = "goToAssets"
    var segueToAlerts = "goToAlerts"
    var cellIdentifier = "categoryCell"
    var selectedIndex  = -1
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateData()
        self.tableView.reloadData()
    }
    
    func updateData(){
        
        var i = 0
        while i < display.count {
            if display[i].alerts.count == 0 {
                display.remove(at: i)
            }
            i += 1
        }
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
        selectedIndex = indexPath.row
        performSegue(withIdentifier: segueToAlerts , sender: self)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return display.count
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            DBMS.delete(alerts: display[indexPath.row].alerts)
            display.remove(at: indexPath.row)
    
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)  as! categoryCell
        cell.setAlert(crypto: display[indexPath.row])
        
        return cell
    }
   
    @IBAction func AddAlert(_ sender: Any) {
        performSegue(withIdentifier:segueToAssets, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueToAssets {
            let destinationVC = segue.destination as! SearchController
            destinationVC.alertDelegate = self
        } else if segue.identifier == segueToAlerts {
            let destinationVC = segue.destination as! AlertController
            destinationVC.crypto = display[selectedIndex]
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
