//
//  PopupController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/9/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class PopupController: UIViewController {

  @IBOutlet weak  private var belowPrice: UILabel!
  @IBOutlet weak  private var price: UILabel!
  @IBOutlet weak  private var abovePrice: UILabel!
  @IBOutlet weak  private var slider: UISlider!
  @IBOutlet weak  private var sliderPrice: UILabel!
  @IBOutlet weak  private var icon: UIImageView!
  @IBOutlet weak  private var name: UILabel!
  @IBOutlet weak  private var messageView: UIView!
    
    var cryptoName:String?
    var cryptoImg:UIImage?
    var cryptoPrice: Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let cryptoName = cryptoName {
            name.text = cryptoName
        }
        
        if let img = cryptoImg {
            icon.image = img
        }
        
        price.text = "$\(cryptoPrice)"
        sliderPrice.text = "\(cryptoPrice)"
        slider.minimumValue = 0
        slider.maximumValue = cryptoPrice*2
        slider.value = cryptoPrice
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
          sliderPrice.text = "\(Double(sender.value).rounded(places: 2))"
          sliderPrice.sizeToFit()
        
        if slider.value < cryptoPrice {
            belowPrice.textColor = UIColor.flatRed()
            abovePrice.textColor = UIColor.lightGray
        } else if slider.value > cryptoPrice {
            belowPrice.textColor = UIColor.lightGray
            abovePrice.textColor = UIColor.flatMintColorDark()
        }
    }
    
}
