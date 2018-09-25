//
//  Product.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
class PetProduct{
    var type:Int
    var productId:Int
    var productCode:String
    var productName:String
    var imagePath:String?
    var price:Float
    
    init(type:Int,productId:Int, productCode:String, productName:String, price:Float, imagePath:String?) {
        self.type = type
        self.productId = productId
        self.productCode = productCode
        self.productName = productName
        self.price = price
        self.imagePath = imagePath
    }
}
