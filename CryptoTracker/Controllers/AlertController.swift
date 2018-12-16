//
//  AlertController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/14/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class AlertController: UITableViewController {

    
    var crypto: Cryptocurrency?
    var cellIdentifier = "alertCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.flatBlueColorDark()
        
        if  crypto?.alerts.isEmpty ?? false  {
            tableView.separatorStyle  = .none
        } else {
            tableView.separatorStyle  = .singleLine
            tableView.tableFooterView = UIView()
        }
        
        if crypto != nil {
            title = crypto!.icon.name + " (" + crypto!.icon.symbol + ")"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return crypto?.alerts.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            DBMS.delete(alerts: [crypto!.alerts[indexPath.row]])
            crypto?.alerts.remove(at: indexPath.row)
          
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
            
            if crypto?.alerts.count == 0 {
                navigationController?.popViewController(animated: true)
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)  as! AlertCell
        cell.setAlert(alert: crypto!.alerts[indexPath.row])
        return cell
    }
}
