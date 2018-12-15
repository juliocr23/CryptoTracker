//
//  CryptoCompare.swift
//  Stock
//
//  Created by Julio Rosario on 9/21/18.
//  Copyright © 2018 Julio Rosario. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import AlamofireImage

class CryptoCompare {
    
    //URLs for Data request
    static let priceUrl  = "https://min-api.cryptocompare.com/data/pricemultifull?"
    static let minUrl = "https://min-api.cryptocompare.com/data/histominute?"
    static let hourUrl  = "https://min-api.cryptocompare.com/data/histohour?"
    static let dailyUrl = "https://min-api.cryptocompare.com/data/histoday?"
    static let coinListUrl = "https://min-api.cryptocompare.com/data/all/coinlist"
    static let multiPriceUrl = "https://min-api.cryptocompare.com/data/pricemultifull?"
    
    //Requests parameters
    static let market: String = "USD"
    static var limit: String = "60"
    var priceThreadGroup = DispatchGroup()
    var imageThreadGroup = DispatchGroup()
    var priceCalls = 0
    var imageCalls = 0
                                        //MARK: Cryptocurrency
    //-----------------------------------------------------------------------------------------------------\\
    func downloadCryptos(completion:(()->())?){
        getJsonRequest(url: CryptoCompare.coinListUrl,parameters: [:]) {(json) in
            let data  = json["Data"]
            let  url  = json["BaseImageUrl"].stringValue
            self.parseCrypto(json: data, baseUrl:url)
            Cryptocurrency.list.sort(by:{$0.icon.symbol < $1.icon.symbol})
            completion?()
        }
    }
    
    func parseCrypto(json: JSON,baseUrl: String) {
        
        for value in json {
            
            if value.1["IsTrading"].boolValue {
             
                let icon  = Icon()
                icon.name               =  value.1["CoinName"].stringValue
                icon.symbol             =  value.1["Symbol"].stringValue
                icon.id                 =  value.1["Id"].stringValue
                
                let temp  = Cryptocurrency(icon: icon)
                temp.favorite           =  false
                Cryptocurrency.list.append(temp)
            }
        }
    }

                                                //MARK: PRICE
    //---------------------------------------------------------------------------------------------------------\\
    func getPriceRequest(for crypto: [Cryptocurrency], start: Int, end: Int) -> [String: String] {
        
        var cryptos = "";
        
        for i in start..<end {
            if i != end-1 {
                cryptos += crypto[i].icon.symbol + ","
            } else {
                cryptos += crypto[i].icon.symbol
            }
        }
        
        return ["fsyms": cryptos,
                "tsyms": CryptoCompare.market]
    }
    
    func downloadPrices(completion:(()->())?){
        var i = 0
        var size = 0
        while i < Cryptocurrency.list.count-60 {
            
            if i + 60 < Cryptocurrency.list.count {
                size = i + 60
            }else {
                size = Cryptocurrency.list.count
            }
            processPriceDownload(begin: i, last: size)
            i += 60
        }
        
        priceTaskCompleted(completion: completion)
    }
    
    private  func  processPriceDownload(begin: Int, last: Int){
        
        let url = CryptoCompare.multiPriceUrl
        let request = self.getPriceRequest(for: Cryptocurrency.list,
                                           start: begin,
                                           end: last)
        
        priceThreadGroup.enter()
        Alamofire.request(url, method: .get, parameters: request).responseJSON {
            response in
            
            if response.result.isSuccess {
                
                let json = JSON(response.result.value!)
                self.getPrice(json: json["RAW"],start: begin, end: last)
                
                self.priceCalls += 1
                print("\(self.priceCalls)")
                self.priceThreadGroup.leave()
            }
            else {
                self.priceThreadGroup.leave()
                print("Error \(String(describing: response.result.error))")
            }
          
        }
    }
    
    func getPrice(json: JSON, start: Int, end: Int) {
        for value in json {
            
            let result = binarySearch(crypto: Cryptocurrency.list,
                                      start: start,
                                      end: end,
                                      key: value.0.lowercased())
            if result != -1 {
                let price =  parsePrice(raw: value.1[CryptoCompare.market])
                Cryptocurrency.list[result].price = price
            }
        }
    }
    
    func parsePrice(raw: JSON) -> Price {
        
        let price = Price()
        price.price        = raw["PRICE"].doubleValue.rounded(places: 2)
        price.supply       = raw["SUPPLY"].doubleValue.rounded(places: 2)
        price.highDay      = raw["HIGHDAY"].doubleValue.rounded(places: 2)
        price.lowDay       = raw["LOWDAY"].doubleValue.rounded(places: 2)
        price.volume24H    = raw["TOTALVOLUME24HTO"].doubleValue.rounded(places: 2)
        price.marketCap    = raw["MKTCAP"].doubleValue.rounded(places: 2)
        price.change24H    = raw["CHANGEPCT24HOUR"].doubleValue.rounded(places: 2)
        
        return price
    }
    
                                        //MARK: Historical Data
    //-------------------------------------------------------------------------------------------------------------\\
   static func requestHistory(for crypto: String) -> [String: String] {
        return ["fsym": crypto,
               "tsym": market,
               "limit": limit,
               "extraParams": "Stock"]
    }
    
  static func requestAllHistory(for crypto: String) -> [String: String] {
        return ["fsym": crypto,
                "tsym": market,
                "allData":"true",
                "e": "CCCAGG",
                "extraParams": "Stock"]
    }
    
                                    //MARK: Completion
    //-------------------------------------------------------------------------\\
    
   private func priceTaskCompleted(completion:(()->())?) {
    
        priceThreadGroup.notify(queue: .main) {
            
            //Remove crypto where price do not exist or  price = < 1
            Cryptocurrency.list = Cryptocurrency.list.filter {
                if $0.price == nil {
                    return false
                }
                return true
            }
            print("Size of cryptocurrencies \(Cryptocurrency.list.count)")
            completion?()
        }
    }
}
