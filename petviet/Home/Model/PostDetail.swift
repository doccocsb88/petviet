//
//  PostDetail.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import ObjectMapper
class PostDetail:Mappable {
    var postId:Int32
    var key:String
    var category_id:Int
    var created_user:String
    var userName:String
    var story:String
    var imagePath:String?
    var youtubePath:String?
    var created_date:Int64
    var likes:[UserLike] = []
    required init?(map: Map) {
        self.postId = 0
        self.key = ""
        self.category_id = 0
        self.created_user = ""
        self.userName = ""
        self.story = ""
        self.imagePath =  ""
        self.youtubePath = ""
        self.created_date = 0
    }
    
    func mapping(map: Map) {
        self.postId <- map["postId"]
        self.key  <- map["key"]
        self.category_id  <- map["category_id"]
        self.created_user  <- map["created_user"]
        self.userName  <- map["userName"]
        self.story <- map["story"]
        self.imagePath   <- map["imagePath"]
        self.youtubePath  <- map["youtubePath"]
        self.created_date  <- map["created_date"]
        self.likes  <- map["likes"]

    }
    

    init(_ postId:Int32, _ category_id:Int, _ userId:String,_ username:String, _ story:String, _ imagePath:String?, _ youtubePath:String?, created_date:Int64) {
        self.postId = postId
        self.key = ""
        self.category_id = category_id
        self.created_user = userId
        self.userName = username
        self.story = story
        self.imagePath =  imagePath
        self.youtubePath = youtubePath
        self.created_date = created_date
        
    }
    
    func isLiked( _ userId:String) ->Bool{
        for user in likes{
            if user.userId == userId{
                return true
            }
        }
        return false
    }
    func userLikedKey(_ userId:String) -> String?{
        for userLiked  in likes{
            if userLiked.userId == userId{
                return userLiked.key
            }
        }
        return nil
    }
    func unLike(_ userId:String){
        var index:Int = NSNotFound
        for i in 0..<likes.count{
            let userLiked = likes[i]
            if userLiked.userId == userId{
                index = i
                break
            }
        }
        if index != NSNotFound {
            likes.remove(at: index)
        }
    }
    func doLike(_ userLike:UserLike){
        likes.append(userLike)
    }
//    func toJson() ->String?{
//
//        do {
//            let jsonEncoder = JSONEncoder()
//            let jsonData = try jsonEncoder.encode(self)
//            let json = String(data: jsonData, encoding: String.Encoding.utf8)
//
//            return json
//        } catch  {
//
//        }
//        return nil
//    }
    
}
