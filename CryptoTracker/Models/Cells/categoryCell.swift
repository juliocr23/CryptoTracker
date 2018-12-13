//
//  AlertCell.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/13/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class categoryCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       backgroundColor = UIColor.flatBlue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setAlert(crypto: Cryptocurrency){
        setName(crypto: crypto)
        setMessage(crypto: crypto)
        icon.image = UIImage(data: crypto.icon.data)
    }

    
   private func setName(crypto: Cryptocurrency){
        var name = ""
        if crypto.icon.name.count <= 10 {
            name = crypto.icon.name
        } else {
            name = crypto.icon.symbol
        }
    
        self.name.text = name
        self.name.textColor = UIColor.white
    }
    
    
    private func setMessage(crypto: Cryptocurrency){
       message.text = "Alerts (\(crypto.alerts.count))"
    }
}
