//
//  Constant.swift
//  petviet
//
//  Created by Hai Vu on 9/27/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
class Constant{
    static var pets:[Pet]{
        var pets:[Pet] = []
        let dog = Pet(type: 1, name: "Chó")
        let cat = Pet(type: 2, name: "Mèo")
        let fish = Pet(type: 3, name: "Cá")
        let hamster = Pet(type: 4, name: "Hamster")
        let arthropods = Pet(type: 5, name: "Chân đốt")
        let reptile = Pet(type: 6, name: "Bò sát")
        pets.append(dog)
        pets.append(cat)
        pets.append(fish)
        pets.append(hamster)
        pets.append(arthropods)
        pets.append(reptile)
        return pets
    }
    static func getPetById(_ type:Int) -> Pet?{
        for pet in pets{
            if pet.type == type{
                return pet
            }
        }
        return nil
    }
}

enum StoryType:Int{
    case image,youtube
}
