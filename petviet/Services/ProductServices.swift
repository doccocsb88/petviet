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
    fileprivate let PATH_SHOP = "shops"

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
    func openShop(_ shop:PetShop, complete:@escaping(_ success:Bool, _ message:String?,_ shop:PetShop)->Void){
        guard let user = Auth.auth().currentUser else{return}
        let shopRef = ref.child(PATH_SHOP).childByAutoId()
        shop.shopId = user.uid
        //
        
        var data:[String:Any] = shop.toJSON()
        data.removeValue(forKey: "key")
        shopRef.setValue(data) { (error, dataRef) in
            if let error = error{
                complete(false,error.localizedDescription,shop)
            }else{
                shop.key = shopRef.key ?? ""
                complete(true,nil,shop)
            }
        }
        
        
        
    }
    func addProduct(_ product:PetProduct, _ shop:PetShop, complete:@escaping(_ success:Bool,_ message:String?,_ key: String?)->Void){
        let productRef = ref.child(PATH_PRODUCT)
        let child = productRef.childByAutoId()
        var data:[String:Any] = product.toJSON()

//        data["shops"] = shop.toJSON()
        data["shops"] = shop.key

        child.setValue(data) { (error, dataRef) in
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
                                if let imagePaths = productDict["imagePath"] as? [String:Any]{
                                    for key in imagePaths.keys{
                                        if let path = imagePaths[key] as? String{
                                            product.imagePath.append(path)
                                        }
                                    }
                                }else if let imagePath = productDict["imagePath"] as? String{
                                    product.imagePath.append(imagePath)

                                }
                                products.append(product)

                            }
                        }
                    }
                }
            }
            complete(products)
        }
    }
    func fetchShop(_ shopId:String, complete:@escaping(_ shop:PetShop?)->Void){
        var shop:PetShop?
        let shopRef = ref.child(PATH_SHOP).child(shopId)
        shopRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict  = snapshot.value as? [String:Any]{
            
                if let _shop = PetShop(JSON: dict){
                    _shop.key = snapshot.key
                    shop = _shop
                    
                }
            }
            complete(shop)
        }
    }
    func fetchShops(complete:@escaping(_ shops:[PetShop])->Void){
        var shops:[PetShop] = []
        let shopRef = ref.child(PATH_SHOP)
        shopRef.observeSingleEvent(of: .value) { (snapshot) in
            for child in snapshot.children{
                if let dict = child as? DataSnapshot {
                    if let shopDict =  dict.value as? [String:Any]{
                        if let shop = PetShop(JSON: shopDict){
                            shop.key = dict.key
                            shops.append(shop)
                        }
                    }
                }
            }
            complete(shops)
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
    func uploadImages(_ datas:[Data],_ prefixName:(String),complete:@escaping(_ urls:[String]) -> Void){
        var urls:[String] = []
        var count = 0
        for data in datas{
            let name = "\(prefixName)_\(String.randomString(length: 10))"
            uploadImage(data, name: name) { (success, message, url) in
                count += 1
                if let url = url{
                    urls.append(url.absoluteString)

                }
                if count == datas.count{
                    complete(urls)
                }
            }
        }
        
    }
}
