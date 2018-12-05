//
//  DetailController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/5/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit

class DetailController: UIViewController {

    @IBOutlet weak var supply: UILabel!
    @IBOutlet weak var volume: UILabel!
    @IBOutlet weak var highDay: UILabel!
    @IBOutlet weak var lowDay: UILabel!
    @IBOutlet weak var marketCap: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var percentageChange: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    
    var crypto:Cryptocurrency!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      print(crypto?.name)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
