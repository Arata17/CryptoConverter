//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Shakhaidar Miras
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoinPrice(_ coinManager: CoinManager, coin: CoinModel)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = ""
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url){(data, response, error) in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let coin = self.parseJson(safeData){
                        self.delegate?.didUpdateCoinPrice(self, coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJson(_ data: Data) -> CoinModel?{
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let currencyName = decodedData.asset_id_quote
            
            let coinModel = CoinModel(price: lastPrice, currencyName: currencyName)
            return coinModel
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
}
