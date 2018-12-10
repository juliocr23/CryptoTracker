//
//  PopupController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/9/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class PopupController: UIViewController {

    @IBOutlet weak var belowPrice: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var abovePrice: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func CreateAlert(_ sender: UIButton) {
    }
    
    @IBAction func cancelAlert(_ sender: UIButton) {
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
        
    }
}
