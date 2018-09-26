//
//  DataServices.swift
//  petviet
//
//  Created by Hai Vu on 9/26/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
class DataServices {
    var profile:PetProfile!
    
    static let sharedInstance : DataServices = {
        let instance = DataServices()
        return instance
    }()
    
    
    init(){
        profile = PetProfile()
    }
    class func shared() -> DataServices {
        return sharedInstance
    }
    
    func isFollowed(_ userId:String) ->Bool{
        let following = profile.following()
        
        for follow in following{
            if follow.toId == userId{
                return true
            }
        }
        return false
    }
    func unFollow( _ follow : PetFollow){
        if let index = profile.follows.index(where: {$0.toId == follow.toId}) {
            profile.follows.remove(at: index)
        }
    }
}
