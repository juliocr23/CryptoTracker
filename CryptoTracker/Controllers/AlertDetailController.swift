//
//  AlertDetailController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/7/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class AlertDetailController: UITableViewController,AlertProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func setAlert(crypto: Cryptocurrency) {
        print(crypto)
      
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
}
