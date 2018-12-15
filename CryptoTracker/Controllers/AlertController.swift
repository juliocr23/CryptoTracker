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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)  as! AlertCell
        cell.setAlert(alert: crypto!.alerts[indexPath.row])
        return cell
    }
  
}
