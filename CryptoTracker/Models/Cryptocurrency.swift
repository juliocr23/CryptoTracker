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
    var favorite: Bool = false
    var price:Price!
    var icon: Icon!
    static var list:[Cryptocurrency] = [Cryptocurrency]()
}
