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

struct Cryptocurrency {
    var id:String = ""
    var name:String = ""
    var symbol:String = ""
    var favorite: Bool = false
    var imageData: ImageData!
    var imageUrl: String = ""
    var price:Price!
    
    static var list:[Cryptocurrency] = [Cryptocurrency]()
}
