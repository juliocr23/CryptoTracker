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

class ViewController: UIViewController {
    var cryptoComp = CryptoCompare()
    var numberOfRequestProcessed:Float = 0.0
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        cryptoComp.downloadCryptos {
            if DBMS.exist() {
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
            }
        }
    }
    
    
    //MARK: Images
    //------------------------------------------------------------------------------//
    func downloadImages(){
        self.cryptoComp.downloadImages(completion: {
            self.updateProgressBar()
        })
    }
    
    func loadImages(){
        
        if let imagesData = DBMS.getImages() {
            
            print("Loading images")
            var notFound = 0
            for i in 0..<imagesData.count {
                
                let result = binarySearch(crypto: Cryptocurrency.list,
                                          start: 0,
                                          end: Cryptocurrency.list.count,
                                          key: imagesData[i].id!)
                if result != -1 {
                    Cryptocurrency.list[result].imageData = imagesData[i]
                } else {
                    notFound += 1
                }
            }
            
            print("not found \(notFound)")
        } else {
            print("Data do not exist")
            return
        }
        
        Cryptocurrency.list =  Cryptocurrency.list.filter{ $0.imageData !=  nil }
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

