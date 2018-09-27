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
    
    func addProduct(_ product:PetProduct, complete:@escaping(_ success:Bool,_ message:String?,_ key: String?)->Void){
        let productRef = ref.child(PATH_PRODUCT)
        let child = productRef.childByAutoId()
        child.setValue(product.toJSON()) { (error, dataRef) in
            if let error = error{
                complete(false,error.localizedDescription,nil)
            }else{
                complete(true,nil,child.key)
            }
        }
        
    }
    func fetchProducts(_ pet:Pet, _ type:ProductType, complete:@escaping(_ products:[PetProduct])->Void){
        let productRef = ref.child(PATH_PRODUCT)
        let child  = productRef.queryOrdered(byChild: "catId").queryEqual(toValue: type.id)
        var products:[PetProduct] = []
        child.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children{
                if let dict = child as? DataSnapshot {
                    if let productDict =  dict.value as? [String:Any]{
                        print("product %@",Utils.convertToJSON(productDict))
                        let petId = productDict["petId"] as? Int ?? 0
                        if petId == pet.type{
                            if let product = PetProduct(JSON: productDict){
                                products.append(product)
                            }
                        }
                    }
                }
            }
            complete(products)
        }
        
    }
    func uploadImage(_ data:Data, name:String,complete:@escaping (_ success:Bool, _ message:String?, _ imageUrl:URL?)->Void){
        guard let _ = Auth.auth().currentUser else{
            return
        }
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        
        // Create a reference to the file you want to upload
//        let name = String(format: "%@.jpg",String.randomString(length: 32))
        let path = String(format: "products/%@.jpg",name)
        //        let localFile = URL(string: pathToImage)!
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(path)
        let metadata = StorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putData(data, metadata: metadata) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                NSLog("uploadImage: %@", error?.localizedDescription ?? "ccccc")
                complete(false,error?.localizedDescription,nil)
                
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    NSLog("downloadURL: %@", error?.localizedDescription ?? "ccccc")
                    
                    complete(false,error?.localizedDescription,nil)
                    
                    return
                }
                
                complete(true,nil,downloadURL)
                
                
            }
        }
       
    }
}
