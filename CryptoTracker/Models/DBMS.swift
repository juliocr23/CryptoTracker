//
//  DBMS.swift
//  Stock
//
//  Created by Julio Rosario on 11/24/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DBMS {
   static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   static var images: [ImageData]? = getImages()
    
    static func saveData(){
        do {
            try context.save()
            print("Data Save!")
        }
        catch {
            print("Error saving Context \(error)")
        }
    }
    
    static func deleteAllImageData(){
        let temp = DBMS.getImages()!
        for value in temp {
            context.delete(value)
        }
        saveData()
        print("Data deleted!")
    }
    
    
    static func exist()->Bool{
       return images != nil ? images!.count != 0: false
    }
    
    
    static func getImg(for name:String)->ImageData? {
        let request: NSFetchRequest<ImageData> = ImageData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", name)
        
        var temp = [ImageData]()
        do {
            temp = try context.fetch(request)
        }catch {
            print("Error getting available cryptocurrencies \(error)")
        }
        
        if temp.count == 0{
            return nil
        } else {
             return temp[0]
        }
    }
    
    static func getImages()->[ImageData]? {
          let request: NSFetchRequest<ImageData> = ImageData.fetchRequest()
          request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        do {
            var temp = [ImageData]()
            temp = try context.fetch(request)
            return temp
        }catch {
            print("Error getting available cryptocurrencies \(error)")
        }
        
        return nil
    }
}
