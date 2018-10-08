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
        let rabit = Pet(type: 7, name: "Thỏ kiểng")
        let squarel = Pet(type: 8, name: "Sóc kiểng")
        let bosat = Pet(type: 9, name: "Bò sát & Rồng nam mỹ")
        let snake = Pet(type: 10, name: "Rắn")
        let spider = Pet(type: 11, name: "Nhện")

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
enum PetGender:Int,CustomStringConvertible{
    case female,male,other
    var description: String{
        switch self {
        case .female:
            return "Giống cái"
        case .male:
            return "Giống đực"
        case .other:
            return "Khác"
        }
    }
}
enum PetColor:Int,CustomStringConvertible{
    case black,white,yellow,brown,other
    var description: String{
        switch self {
        case .black:
            return "Màu đen"
        case .white:
            return "Màu trắng"
        case .yellow:
            return "Vàng mơ"
        case .brown:
            return "Nâu đỏ"
        default:
            return "Bất kì"
        }
    }
}
