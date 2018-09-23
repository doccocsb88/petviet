//
//  ProductType.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
class ProductType{
    var id:Int
    var type:Int
    var productName:String
    var typeName:String
    init(_ id:Int, _ type:Int, _ productName:String, _ typeName:String){
        self.id = id
        self.type = type
        self.productName = productName
        self.typeName = typeName
    }
}
