//
//  PetShop.swift
//  petviet
//
//  Created by Macintosh HD on 9/27/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper
class PetShop:Mappable{
   
    var key:String = ""
    var shopId:String = ""
    var shopName:String = ""
    var description:String = ""
    var address:String = ""
    var phone:String = ""
    var cellPhone:String = ""
    var imagePath:String = ""
    var cityId:Int = 0
    init(){}
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        shopId <- map["shopId"]
        shopName <- map["shopName"]
        description <- map["description"]
        address <- map["address"]
        phone <- map["phone"]
        cellPhone <- map["cellPhone"]
        cityId <- map["cityId"]
        imagePath <- map["imagePath"]
    }
   
}
