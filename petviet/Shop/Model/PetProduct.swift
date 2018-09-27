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
    var catId:Int = 0
    var petId:Int = 0
    var productCode:String = ""
    var productName:String = ""
    var imagePath:String? = ""
    var price:Float = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        catId <- map["catId"]
        petId <- map["petId"]
        productCode <- map["productCode"]
        productName <- map["productName"]
        imagePath <- map["imagePath"]
        price <- map["price"]

    }
    
  
    
    init(catId:Int, petId:Int, productCode:String, productName:String, price:Float, imagePath:String?) {
        self.catId = catId
        self.petId = petId
        self.productCode = productCode
        self.productName = productName
        self.price = price
        self.imagePath = imagePath
    }
    func toJSON() -> [String : Any] {
        var json:[String:Any] = [:]
        json["catId"] = self.catId
        json["petId"] = self.petId
        json["productName"] = self.productName
        json["productCode"] = self.productCode
        json["price"] = self.price
        json["imagePath"] = self.imagePath ?? ""

        return json
    }
}
