//
//  DBMS.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/13/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DBMS  {
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveData(){
        do {
            try context.save()
            print("Data Save!")
        }
        catch {
            print("Error saving Context \(error)")
        }
    }
    
    static func deleteAlerts(){
        let alerts = getAlerts()
        
        for value in alerts {
            context.delete(value)
        }
        saveData()
        print("Alerts deleted")
    }
    
    static func getAlerts(for symbol:String)->[PriceAlert]? {
        let request: NSFetchRequest<PriceAlert> = PriceAlert.fetchRequest()
        request.predicate = NSPredicate(format: "symbol == %@", symbol)
        
        var temp = [PriceAlert]()
        do {
            temp = try context.fetch(request)
        }catch {
            print("Error getting available cryptocurrencies \(error)")
        }
        
        return temp
    }
    
    static func getAlerts()->[PriceAlert] {
        let request: NSFetchRequest<PriceAlert> = PriceAlert.fetchRequest()
        
        var temp = [PriceAlert]()
        do {
            temp = try context.fetch(request)
        }catch {
            print("Error getting available cryptocurrencies \(error)")
        }
        return temp
    }
}
