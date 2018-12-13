//
//  AlertCell.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/13/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class AlertCell: UITableViewCell {
    
    @IBOutlet weak var icon: UILabel!
    @IBOutlet weak var alertMessage: UILabel!
    var alert: PriceAlert!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setAlert(alert: PriceAlert) {
        self.alert =  alert
        onOffSwitch.isOn = alert.active
        
        if alert.above {
            icon.text = "📈"
            alertMessage.text = "\(alert.symbol!) is above \(alert.price)"
        } else {
            icon.text = "📉"
            alertMessage.text = "\(alert.symbol!) is below \(alert.price)"
        }
        
    }

    @IBAction func switchEvent(_ sender: UISwitch) {
        
        if let alert = alert {
          alert.active = sender.isOn
          DBMS.saveData()
        }else {
            print("Crypt is nil in alert cell")
        }
    }
}
