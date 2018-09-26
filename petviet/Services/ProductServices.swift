//
//  ProductServices.swift
//  petviet
//
//  Created by Macintosh HD on 9/26/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
class ProductServices {
    fileprivate let PATH_PRODUCT = "products"
    
    var ref: DatabaseReference!
    
    static let sharedInstance : ProductServices = {
        let instance = ProductServices()
        return instance
    }()
    
    
    init(){
        ref = Database.database().reference()
        
    }
    class func shared() -> ProductServices {
        return sharedInstance
    }
    
    func addProduct(_ product:PetProduct){
        let productRef = ref.child(PATH_PRODUCT)
        
    }
}
