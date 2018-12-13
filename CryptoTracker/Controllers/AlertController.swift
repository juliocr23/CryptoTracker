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
 
Missing DB for price Alert
 and background thread to request for price for those priceAlert
 Need to learn how to send notification
 and how to allow the app to run in the background
 
 */
class AlertController: UITableViewController,AlertProtocol,PopupProtocol {
    

    var crypto: Cryptocurrency?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.flatBlueColorDark()
        tableView.separatorStyle = .none
    }
    
    
    //MARK: Protocol methods
    func setAlert(crypto: Cryptocurrency) {
       
        self.crypto = crypto
        let storyBrd = UIStoryboard(name: "Popup", bundle: nil)
        let popup = storyBrd.instantiateInitialViewController()! as! PopupController
        
        popup.cryptoName  = crypto.icon.name
        popup.cryptoImg   = UIImage(data:crypto.icon.data)
        popup.cryptoPrice = Float(crypto.price.price)
        popup.delegate    = self
        present(popup, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func getPriceAlert(priceAlert: Double,above: Bool) {
       //Create DB for Alert
        print("Creating Alert for price for \(priceAlert)")
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
