//
//  PopupController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/9/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit


/*
 Note when tapping it deletes
 */

protocol  PopupProtocol {
    func getPriceAlert(priceAlert: Double,above: Bool);
}

class PopupController: UIViewController {

  @IBOutlet weak  private var belowPrice: UILabel!
  @IBOutlet weak  private var price: UILabel!
  @IBOutlet weak  private var abovePrice: UILabel!
  @IBOutlet weak  private var slider: UISlider!
  @IBOutlet weak  private var icon: UIImageView!
  @IBOutlet weak  private var name: UILabel!
  @IBOutlet weak  private var messageView: UIView!
  @IBOutlet weak var createPriceAlertLabel: UILabel!
    
    var cryptoName:String?
    var cryptoImg:UIImage?
    var cryptoPrice: Float = 0
    var delegate:PopupProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setName()
        setImage()
        price.text = "$\(cryptoPrice)"
        setSlider()
        setTapRecognition()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
        
      price.text = "\(Double(sender.value).rounded(places: 2))"
      price.sizeToFit()
        
        if slider.value < cryptoPrice {
            createPriceAlertLabel.textColor = UIColor.flatWhite()
            belowPrice.textColor = UIColor.flatRed()?.lighten(byPercentage: 20)
            abovePrice.textColor = UIColor.lightGray
        } else if slider.value == cryptoPrice {
            createPriceAlertLabel.textColor = UIColor.flatWhiteColorDark()
            belowPrice.textColor = UIColor.lightGray
            abovePrice.textColor = UIColor.lightGray
        }else if slider.value > cryptoPrice {
            createPriceAlertLabel.textColor = UIColor.flatWhite()
            belowPrice.textColor = UIColor.lightGray
            abovePrice.textColor = UIColor.flatGreen()
        }
    }
    
   
   @objc func createNewPriceAlert(sender:UITapGestureRecognizer) {
  
        if let recognizers =  messageView.gestureRecognizers{
            if recognizers[0] == sender {
                
                print("Creating price Alert")
                
                let isAbove = slider!.value > cryptoPrice
                delegate?.getPriceAlert(priceAlert: Double(slider!.value), above:isAbove)
                dismiss(animated: true)
            }
        }
    }
    
    @objc func cancelPriceAlert(sender:UITapGestureRecognizer) {
        if let recognizers = view.gestureRecognizers {
            if recognizers[0] == sender {
                  print("Clicking outside of popup")
                  dismiss(animated: true)
            }
        }
    }
    
    func setName(){
        if let cryptoName = cryptoName {
            name.text = cryptoName
        }
    }
    
    func setImage(){
        if let img = cryptoImg {
            icon.image = img
        }
    }
    
    func setSlider(){
        price.text = "\(cryptoPrice)"
        
        if cryptoPrice == 0 {
            slider.minimumValue = -1
            slider.maximumValue = 1
        } else {
             slider.minimumValue = 0
            slider.maximumValue = cryptoPrice*2
        }
        slider.value = cryptoPrice
        
        createPriceAlertLabel.textColor = UIColor.flatWhiteColorDark()
        belowPrice.textColor = UIColor.lightGray
        abovePrice.textColor = UIColor.lightGray
    }
    
    func setTapRecognition(){

        let cancelAlertTap = UITapGestureRecognizer(target: self,
                                                    action: #selector(cancelPriceAlert))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(cancelAlertTap)
        
        let createAlertTap = UITapGestureRecognizer(target: self,
                                                    action: #selector(createNewPriceAlert))
        messageView.isUserInteractionEnabled = true
        messageView.addGestureRecognizer(createAlertTap)
    }
    
}
