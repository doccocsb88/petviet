//
//  PetComment.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper
class PetComment:Mappable{
    var key:String = ""
    var userId:String = ""
    var userDisplayName:String = ""
    var message:String = ""
    var created_date:Int64 = 0
    var to_user:String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        userDisplayName <- map["userDisplayName"]
        message <- map["message"]
        created_date <- map["created_date"]
        to_user <- map["to_user"]

    }
    init(_ message:String) {
        self.message = message
        self.created_date = Date().millisecondsSince1970
    }
   
    
}
