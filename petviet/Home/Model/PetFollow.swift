//
//  UserFollow.swift
//  petviet
//
//  Created by Macintosh HD on 9/25/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper
class PetFollow:Mappable {
    var fromId:String
    var fromName:String
    var toId:String
    var toName:String
    var key:String
    init(_ fromId:String, _ fromName:String, _ toId:String, _ toName: String){
        self.fromId = fromId
        self.fromName = fromName
        self.toId = toId
        self.toName = toName
        key = ""
    }
    required init?(map: Map) {
        fromId = ""
        fromName = ""
        toId = ""
        toName = ""
        key = ""
    }
    func mapping(map: Map) {
        self.fromId <- map["fromId"]
        self.fromName <- map["fromName"]
        self.toId <- map["toId"]
        self.toName <- map["toName"]
    }
    func toJSON() -> [String : Any] {
        var json:[String:Any] = [:]
        json["fromId"] = fromId
        json["fromName"] = fromName
        json["toId"] = toId
        json["toName"] = toName

        return json
    }
}

