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
        let arthropods = Pet(type: 5, name: "Nhím kiểng")
        let reptile = Pet(type: 6, name: "Bọ ú")
        let rabit = Pet(type: 6, name: "Thỏ kiểng")
        let squarel = Pet(type: 6, name: "Sóc kiểng")
        let bosat = Pet(type: 6, name: "Bò sát & Rồng nam mỹ")
        let snake = Pet(type: 6, name: "Rắn")
        let spider = Pet(type: 6, name: "Nhện")

        pets.append(dog)
        pets.append(cat)
        pets.append(fish)
        pets.append(hamster)
        pets.append(arthropods)
        pets.append(reptile)
        pets.append(rabit)
        pets.append(squarel)
        pets.append(bosat)
        pets.append(snake)
        pets.append(spider)

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
