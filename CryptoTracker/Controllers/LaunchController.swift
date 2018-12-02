//
//  ViewController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 11/30/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

/*
 ->If database is created do not show launch screen?
 otherwise-> show Launch screen.
 */

class LaunchController: UIViewController {
    
    var cryptoComp = CryptoCompare()
    var numberOfRequestProcessed:Float = 0.0
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cryptoComp.downloadCryptos {
            
            self.cryptoComp.downloadPrices(completion: {
                self.downloadImages()
                self.cryptoComp.imagesTaskCompleted(completion: {
                    self.performSegue(withIdentifier: "goToTabBarController", sender: self)
                })
            })
            
            
            /*if DBMS.exist() {
             self.loadImages()
             self.cryptoComp.downloadPrices(completion: {
             self.performSegue(withIdentifier: "goToTabBarController", sender: self)
             })
            } else{
                self.cryptoComp.downloadPrices(completion: {
                    self.downloadImages()
                      self.cryptoComp.imagesTaskCompleted(completion: {
                        self.performSegue(withIdentifier: "goToTabBarController", sender: self)
                    })
                })
            }*/
        }
    }
    
    //MARK: Images
    //------------------------------------------------------------------------------//
    func downloadImages(){
        self.cryptoComp.downloadImages(completion: {
            self.updateProgressBar()
        })
    }
    
    func updateProgressBar(){
        DispatchQueue.main.async {
            self.numberOfRequestProcessed += 1
            let progress = self.numberOfRequestProcessed / Float(Cryptocurrency.list.count)
            print(progress)
            self.progressBar.progress = progress
        }
    }
}

