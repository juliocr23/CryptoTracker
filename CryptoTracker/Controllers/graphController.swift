//
//  DetailController.swift
//  CryptoTracker
//
//  Created by Julio Rosario on 12/5/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import UIKit
import Charts
import SwiftyJSON
import SVProgressHUD

class graphController: UIViewController {

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
    @IBOutlet weak var graphView: CandleStickChartView!
    @IBOutlet var graphButtons: [UIButton]!
    
    
    var cryptoComp:CryptoCompare = CryptoCompare()
    var crypto:Cryptocurrency!
    
    var graphModel = Graph()
    var historicalData: [HistoricalData]!
    var graphIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
      SVProgressHUD.show()
      print("Crypto is \(crypto.icon.name)")
      showPrice()
      displayGraph()
    }
    
    //MARK: Price methods
    //------------------------------------------------------------------------------------------\\
    func showPrice(){
        
        showIcon()
        showPercentage()
        
        name.text = crypto.icon.name
        symbol.text = crypto.icon.symbol
        
        percentageChange.text     = "(\(crypto.price.change24H.rounded(places: 2))%) 24H"
        price.text                = "$" + String(crypto.price.price)
        lowDay.text               = "$" + String(crypto.price.lowDay)
        highDay.text              = "$" + String(crypto.price.highDay)
        volume.text               = "$" + getDisplayFormat(number: crypto.price.volume24H)
        supply.text               =       getDisplayFormat(number: crypto.price.supply)
        marketCap.text            = "$" + getDisplayFormat(number: crypto.price.marketCap)
    }
    
    private func showIcon(){
        if let data = crypto.icon  {
            icon.image = UIImage(data: data.data!)
            icon.backgroundColor = UIColor(named: "default")
        }else{
            print("Image in Detail not found for \(crypto.icon.name)")
        }
    }
    
    private func showPercentage(){
        if crypto.price.change24H >= 0 {
            percentageChange.textColor = UIColor.green
        } else {
            percentageChange.textColor = UIColor.red
        }
        
    }
    
    //MARK: Graph methods
    private func displayGraph(){
        
        print("Parameters \(getParameters())")
        getJsonRequest(url: getURL(),parameters: getParameters()) {(json) in
            self.parseHistoricalData(json: json)
            self.setGraph()
            SVProgressHUD.dismiss()
        }
    }
    
    private func getURL()->String{
        switch graphIndex {
        case 0:
            return CryptoCompare.minUrl
        case 1:
            return CryptoCompare.hourUrl
        default:
            return CryptoCompare.dailyUrl
        }
    }
    
    private func getParameters()->[String:String] {
        switch graphIndex {
        case 0,1,2,3,4:
            return  cryptoComp.requestHistory(for:crypto.icon.symbol)
        default:
            return  cryptoComp.requestAllHistory(for:crypto.icon.symbol)
        }
    }
    
    private func getLimit(index: Int)->String{
        switch index {
        case 0:
            return "60"
        case 1:
            return "24"
        case 2:
            return "7"
        case 3:
            return "31"
        case 4:
            return "365"
        default:
            return ""
        }
    }
    private func setGraph(){
        
            graphView.data = graphModel.getData(data: historicalData)
            graphView.leftAxis.enabled = false
            graphView.rightAxis.enabled = false
            graphView.xAxis.enabled = false
            graphView.setScaleEnabled(false)
            graphView.setNeedsDisplay()
            graphView.dragEnabled = false
            graphView.legend.drawInside = false
    }
    
   private func parseHistoricalData(json: JSON){
        historicalData =  [HistoricalData]()
        
        for value in json["Data"] {
            
            let newEntry          =  HistoricalData()
            newEntry.open         =  value.1["open"].doubleValue
            newEntry.high         =  value.1["high"].doubleValue
            newEntry.low          =  value.1["low"].doubleValue
            newEntry.close        =  value.1["close"].doubleValue
            newEntry.volumeFrom   =  value.1["volumefrom"].doubleValue
            newEntry.volumeTo     =  value.1["volumeto"].doubleValue
            historicalData.append(newEntry)
        }
    }
    func chngGraphBttnColor(index: Int){
        
        graphButtons[graphIndex].backgroundColor = UIColor(named: "default")
        graphIndex = index
        graphButtons[graphIndex].backgroundColor = UIColor(hexString: "#8898D0")
    }
    
    //MARK: Graphs Events
    //----------------------------------------------------------\\
    @IBAction func show1Hr(_ sender: UIButton) {
        
        print("One hour graph")
        if graphButtons[graphIndex] != sender  {
           
             SVProgressHUD.show()
             chngGraphBttnColor(index: 0)
            
             cryptoComp.limit = getLimit(index: graphIndex)
             displayGraph()
        }
    }
    
    @IBAction func show1Day(_ sender: UIButton) {
        
        print("one day graph")
        if graphButtons[graphIndex] != sender  {
            
            SVProgressHUD.show()
            chngGraphBttnColor(index: 1)
            
            cryptoComp.limit = getLimit(index: graphIndex)
            displayGraph()
        }
    }
    
    
    @IBAction func show1Week(_ sender: UIButton) {
        
        print("one Week graph")
        if graphButtons[graphIndex] != sender  {
            
            SVProgressHUD.show()
            chngGraphBttnColor(index: 2)
            
            cryptoComp.limit = getLimit(index: graphIndex)
            displayGraph()
        }
    }
    
    
    @IBAction func show1Month(_ sender: UIButton) {
        
        print("one month graph")
        if graphButtons[graphIndex] != sender  {
            
            SVProgressHUD.show()
            chngGraphBttnColor(index: 3)
            
            cryptoComp.limit = getLimit(index: graphIndex)
            displayGraph()
        }
    }
    
    @IBAction func show1Year(_ sender: UIButton) {
        
        print("one year graph")
        if graphButtons[graphIndex] != sender  {
            
            SVProgressHUD.show()
            chngGraphBttnColor(index: 4)
         
            cryptoComp.limit = getLimit(index: graphIndex)
            displayGraph()
        }
    }
    
    @IBAction func showAll(_ sender: UIButton) {
        
        print("All time graph")
        if graphButtons[graphIndex] != sender  {
            
            SVProgressHUD.show()
            chngGraphBttnColor(index: 5)
            
            displayGraph()
        }
    }
}
