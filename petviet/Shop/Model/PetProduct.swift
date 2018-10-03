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
    var imagePath:[String] = []
    var price:Float = 0
    var maxPrice:Float = 0
    var age:Int = 0
    var gender:Int = 0
    var color:Int = 0
    var description:String = ""
    var shops:String?
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        catId <- map["catId"]
        petId <- map["petId"]
        productCode <- map["productCode"]
        productName <- map["productName"]
        imagePath <- map["imagePath"]
        price <- map["price"]
        maxPrice <- map["maxPrice"]
        maxPrice <- map["maxPrice"]
        age <- map["age"]
        gender <- map["gender"]
        color <- map["color"]

        description <- map["description"]
        shops <- map["shops"]

    }
    
  
    
    init(catId:Int, petId:Int, productCode:String, productName:String, price:Float, imagePath:[String], description:String) {
        self.catId = catId
        self.petId = petId
        self.productCode = productCode
        self.productName = productName
        self.price = price
        self.imagePath = imagePath
        self.description = description
    }
    init(catId:Int, petId:Int, productCode:String, productName:String, price:Float,maxPrice:Float,age:Int, gender:Int, color:Int, imagePath:[String], description:String) {
        self.catId = catId
        self.petId = petId
        self.productCode = productCode
        self.productName = productName
        self.price = price
        self.maxPrice = maxPrice
        self.age = age
        self.imagePath = imagePath
        self.description = description
    }
    func toJSON() -> [String : Any] {
        var json:[String:Any] = [:]
        json["catId"] = self.catId
        json["petId"] = self.petId
        json["productName"] = self.productName
        json["productCode"] = self.productCode
        json["price"] = self.price
        json["maxPrice"] = self.maxPrice
        json["age"] = self.age
        json["gender"] = self.gender
        json["color"] = self.color
        var paths:[String:String] = [:]
        for i in 0..<self.imagePath.count{
            let key = "image_\(i)"
            paths[key] = self.imagePath[i]
        }
        //json["imagePath"] = Utils.convertToJSON(paths)
        json["imagePath"] = paths

        json["description"] = self.description
        json["shops"] = self.shops ?? ""

        return json
    }
}
