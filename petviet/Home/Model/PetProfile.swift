//
//  PetProfile.swift
//  petviet
//
//  Created by Hai Vu on 9/26/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
class PetProfile{
   
    var userId:String = ""
    var email:String = ""
    var displayName:String = ""
    var biography:String = ""
    var follows:[PetFollow] = []

    init() {
        
    }
    
    func followers() -> [PetFollow]{
        var data:[PetFollow] = []
        for follow in follows{
            if follow.toId == userId{
                data.append(follow)
            }
        }
        return data
    }
    func following() -> [PetFollow]{
        var data:[PetFollow] = []
        for follow in follows{
            if follow.fromId == userId{
                data.append(follow)
            }
        }
        return data
    }
    
    func follow(_ follow:PetFollow){
        follows.insert(follow, at: 0)
    }
 
}
