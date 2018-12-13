//
//  PopupController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/9/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

protocol  PopupProtocol {
    func complete(crypto: Cryptocurrency);
}

class PopupController: UIViewController {

  @IBOutlet weak  private var belowPrice: UILabel!
  @IBOutlet weak  private var price: UILabel!
  @IBOutlet weak  private var abovePrice: UILabel!
  @IBOutlet weak  private var slider: UISlider!
  @IBOutlet weak  private var icon: UIImageView!
  @IBOutlet weak  private var name: UILabel!
  @IBOutlet weak  private var createPriceAlertView: UIView!
  @IBOutlet weak var createPriceAlertLabel: UILabel!
  @IBOutlet weak var popUpView: UIView!
    
    var crypto: Cryptocurrency?
    var delegate:PopupProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setName()
        setImage()
        price.text = "$\(crypto!.price.price)"
        setSlider()
        setTapRecognition()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func valueChange(_ sender: UISlider) {
        
      price.text = "\(Double(sender.value).rounded(places: 2))"
      price.sizeToFit()
        
        let priceCrypt = Float(crypto!.price.price)
        if slider.value < priceCrypt {
            createPriceAlertLabel.textColor = UIColor.flatWhite()
            belowPrice.textColor = UIColor.flatRed()?.lighten(byPercentage: 20)
            abovePrice.textColor = UIColor.lightGray
        } else if slider.value == priceCrypt {
            createPriceAlertLabel.textColor = UIColor.flatWhiteColorDark()
            belowPrice.textColor = UIColor.lightGray
            abovePrice.textColor = UIColor.lightGray
        }else if slider.value > priceCrypt {
            createPriceAlertLabel.textColor = UIColor.flatWhite()
            belowPrice.textColor = UIColor.lightGray
            abovePrice.textColor = UIColor.flatGreen()
        }
    }
    
   @objc func createNewPriceAlert(sender:UITapGestureRecognizer) {
  
    let priceCrypt = Float(crypto!.price.price)
    if slider.value !=  priceCrypt,
        let recognizers =  createPriceAlertView.gestureRecognizers{
            if recognizers[0] == sender {
                
                print("Creating price Alert")
                
                let isAbove = slider!.value > priceCrypt
                
                //Create priceAlert
                let priceAlert  = PriceAlert(context: DBMS.context)
                priceAlert.above  = isAbove
                priceAlert.price  = Double(slider!.value).rounded(places: 2)
                priceAlert.date   = Date()
                priceAlert.active = true
                priceAlert.symbol = crypto!.icon.symbol
                crypto!.alerts.append(priceAlert)
                DBMS.saveData()
                
                delegate?.complete(crypto: crypto!)
                dismiss(animated: true)
            }
        }
    }
    
    @objc func cancelPriceAlert(sender:UITapGestureRecognizer) {
        
        let location = sender.location(in: nil)
        
        if  !popUpView.frame.contains(location) {
             print("Clicked out side of popup")
             dismiss(animated: true)
        }
        
    }
    
    func setName(){
        name.text = crypto!.icon.name
    }
    
    func setImage(){
        if let img = UIImage(data: crypto!.icon.data ){
            icon.image = img
        }
    }
    
    func setSlider(){
        price.text = "\(crypto!.price.price)"
        
        let priceCrypt = Float(crypto!.price.price)
        if priceCrypt == 0.0 {
            slider.minimumValue = -1
            slider.maximumValue = 1
        } else {
             slider.minimumValue = 0
            slider.maximumValue = priceCrypt*2
        }
        slider.value = priceCrypt
        
        createPriceAlertLabel.textColor = UIColor.flatWhiteColorDark()
        belowPrice.textColor = UIColor.lightGray
        abovePrice.textColor = UIColor.lightGray
    }
    
    func setTapRecognition(){

        //For when user tap outside the pop up view
        let cancelAlertTap = UITapGestureRecognizer(target: self,
                                                    action: #selector(cancelPriceAlert))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(cancelAlertTap)
        
        let createAlertTap = UITapGestureRecognizer(target: self,
                                                    action: #selector(createNewPriceAlert))
        createPriceAlertView.isUserInteractionEnabled = true
        createPriceAlertView.addGestureRecognizer(createAlertTap)
        
    }
    
}
