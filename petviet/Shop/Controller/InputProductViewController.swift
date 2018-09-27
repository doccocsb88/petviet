//
//  InputProductViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/24/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class InputProductViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productCodeTextfield: UITextField!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var productPriceTextfield: UITextField!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    var productType:ProductType!
    var pet:Pet!
    var productCode:String!
    var image:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLoadingView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "\(pet.name) - \(productType.typeName)"
        productCode =  "pet_\(pet.type)_\(productType.id)_\(String.randomString(length: 6))"
        productCodeTextfield.text = productCode
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func resetInput(){
        productCode =  "pet_\(pet.type)_\(productType.id)_\(String.randomString(length: 6))"
        productCodeTextfield.text = productCode
        productNameTextfield.text = nil
        productPriceTextfield.text = nil
        image = nil
        productImageView.image = image
    }
    @IBAction func tappedIUploadButton(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            self.productImageView.image =  image
            self.image = image

        }
    }
    @IBAction func tappedSaveButton(_ sender: Any) {
        guard let code = productCodeTextfield.text else{return}
        guard let name = productNameTextfield.text else{return}
        guard let price = productPriceTextfield.text else{return}
        guard let image = image else{return}
        let product = PetProduct(catId: productType.id,petId:pet.type, productCode: code, productName: name, price: Float(price) ?? 0.0, imagePath: nil)
        
     
        if let data = UIImagePNGRepresentation(image){
            self.showLoadingView()
            ProductServices.shared().uploadImage(data, name: self.productCode, complete: { (success, message, url) in
                product.imagePath = url?.absoluteString
                ProductServices.shared().addProduct(product) {[weak self] (success, message, key) in
                    guard let strongSelf = self else{return}
                    strongSelf.hideLoadingView()
                    if success{
                        strongSelf.resetInput()
                    }
                }
                
            })
        }
    }

    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

