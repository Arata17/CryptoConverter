//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Shakhaidar Miras
//

import Foundation

struct CoinModel {
    let price: Double
    let currencyName: String
    
    var priceString: String{
        return String(format: "%.2f", price)
    }
}
