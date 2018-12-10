//
//  AlertDetailController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/7/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class AlertDetailController: UITableViewController,AlertProtocol {

    
    var crypto: Cryptocurrency?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.flatBlueColorDark()
        tableView.separatorStyle = .none
    }
    
    func setAlert(crypto: Cryptocurrency) {
       
        self.crypto = crypto
        let storyBrd = UIStoryboard(name: "Popup", bundle: nil)
        let popup = storyBrd.instantiateInitialViewController()! as! PopupController
        
        popup.cryptoName  = crypto.icon.name
        popup.cryptoImg   = UIImage(data:crypto.icon.data)
        popup.cryptoPrice = Float(crypto.price.price)
        present(popup, animated: true)
       // performSegue(withIdentifier: "goToPopup", sender: self)
    }
   
    @IBAction func AddAlert(_ sender: Any) {
        performSegue(withIdentifier: "goFromAlertToSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
           print("Going to popup")
        if segue.identifier == "goFromAlertToSearch" {
            let destinationVC = segue.destination as! SearchController
            destinationVC.alertDelegate = self
        } else if segue.identifier == "goToPopup" {
           
        }
    }
}
