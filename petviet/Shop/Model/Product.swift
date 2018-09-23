//
//  Product.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
class Product{
    var type:ProductType
    var productId:Int
    var productName:String
    init(type:ProductType,productId:Int, productName:String) {
        self.type = type
        self.productId = productId
        self.productName = productName
    }
}
