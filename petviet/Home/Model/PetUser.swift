//
//  PetUser.swift
//  petviet
//
//  Created by Macintosh HD on 9/25/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper
class PetUser:Mappable{
    
    var email:String = ""
    var displayName:String = ""
    var biography:String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        email <-  map["email"]
        displayName <-  map["displayName"]
        biography <-  map["biography"]

    }
   
    
}
