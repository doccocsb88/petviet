//
//  Product.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper
class PetProduct:Mappable{
    var productType:ProductType
    var productCode:String = ""
    var productName:String = ""
    var imagePath:String? = ""
    var price:Float = 0
    required init?(map: Map) {
        productType = ProductType(0,0,0,"","")
    }
    
    func mapping(map: Map) {
        
    }
    
  
    
    init(productType:ProductType, productCode:String, productName:String, price:Float, imagePath:String?) {
        self.productType = productType
        self.productCode = productCode
        self.productName = productName
        self.price = price
        self.imagePath = imagePath
    }
    func toJSON() -> [String : Any] {
        var json:[String:Any] = [:]
        json["type"] = self.productType.id
        json["catId"] = self.productType.type
        json["petId"] = self.productType.petId
        json["productName"] = self.productName
        json["productCode"] = self.productCode
        json["price"] = self.price
        json["imagePath"] = self.imagePath ?? ""

        return json
    }
}
