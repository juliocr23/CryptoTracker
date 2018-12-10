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
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var sliderPrice: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var messageView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
          sliderPrice.text = "\(Double(sender.value).rounded(places: 2))"
          sliderPrice.sizeToFit()
    }
    
}
