//
//  SearchCell.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 11/30/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var logoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.flatBlue()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCrypto(crypto: Cryptocurrency) {
        setName(for: crypto)
        setSymbol(for: crypto)
        setPrice(for: crypto)
        setLogo(for: crypto)
    }
    
    //MARK: Helper
    private func setName(for crypto: Cryptocurrency){
        
        var name = ""
        if crypto.name.count <= 10 {
            name = crypto.name
        } else {
            name = crypto.symbol
        }
        nameLabel.text = name
        nameLabel.textColor = UIColor.white
    }
    
    private func setSymbol(for crypto: Cryptocurrency) {
       symbolLabel.text = crypto.symbol
       symbolLabel.textColor = UIColor.lightGray
    }
    
    private func setPrice(for crypto: Cryptocurrency) {
        
        if let price = crypto.price {
            priceLabel.text  = "\t$\(price.price)\t"
        }else {
            print("Price do not exist for \(crypto.name)")
            return
        }
        
        //Check if it is increasing or decreasing and set color
        if crypto.price.change24H < 0 {
            priceLabel.textColor = UIColor.red
            priceLabel.backgroundColor =  UIColor(hexString: "#ffebe6")
        } else {
            priceLabel.textColor = UIColor(hexString: "#009933")
            priceLabel.backgroundColor = UIColor(hexString: "#E6FFE6")
        }
        
        priceLabel?.layer.cornerRadius = CGFloat((priceLabel.frame.height) * 0.50)
        priceLabel?.layer.masksToBounds = true
        priceLabel?.clipsToBounds = true
    }
    
    private func setLogo(for crypto: Cryptocurrency) {
        
        if let imgData = crypto.imageData  {
            logoImg.image = UIImage(data: imgData.data!)
        }else {
            print("Logo do not exist for \(crypto.name)")
        }
    }
}
