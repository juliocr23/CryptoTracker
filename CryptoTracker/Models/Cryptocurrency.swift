//
//  Cryptocurrency.swift
//  Stock
//
//  Created by Julio Rosario on 11/24/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Cryptocurrency {
    var favorite: Bool = false
    var price:Price!
    var icon: Icon!
    var alerts:[PriceAlert]
    
    init(icon: Icon){
        self.icon = icon
        
        if let priceAlerts = DBMS.getAlerts(for: icon.symbol) {
           alerts = priceAlerts
        }else {
            alerts = [PriceAlert]()
        }
    }
    static var list:[Cryptocurrency] = [Cryptocurrency]()
    
    static func loadImages(){
        do {
            let url:URL  = Bundle.main.url(forResource: "res/images", withExtension: "json")!
            let jsonData = try Data(contentsOf: url)
            
            let jsonDecoder = JSONDecoder()
            let  icons      = try jsonDecoder.decode([Icon].self, from: jsonData)
            
            for value in icons {
                let crypto = Cryptocurrency(icon: value)
                Cryptocurrency.list.append(crypto)
            }
            
        }catch{
            print("Failed reading data")
            print(error)
        }
    }
}
