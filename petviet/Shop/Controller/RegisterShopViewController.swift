//
//  RegisterShopViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/27/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class RegisterShopViewController: BaseViewController {

    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var addressTextfield: UITextField!
    
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    @IBOutlet weak var cellPhoneLabel: UITextField!
    @IBOutlet weak var selectCityButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    
    @IBOutlet weak var descriptionTextview: UITextView!
    
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    var cityId:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Đăng kí mở cửa hàng"
        initLoadingView()
        addDefaultLeft()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        
        self.view.addGestureRecognizer(tap)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    @objc func tappedGesture(_ gesture:UITapGestureRecognizer){
            self.view.endEditing(true)
    }
    override func tappedLeftButton(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func tappedSelectImageButton(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            self.thumbnailImageView.image =  image            
        }
        
    }
    @IBAction func tappedSelectCityButton(_ sender: Any) {
        showActionSheet()
    }
    @IBAction func tappedRegisterButton(_ sender: Any) {
        guard let name = nameTextfield.text else {return}
        guard let address = addressTextfield.text else{return}
        guard let description = descriptionTextview.text, description.count > 0 else{return}
        guard let image = thumbnailImageView.image else {return}
        let phone = phoneNumberTextfield.text
        let cellPhone = cellPhoneLabel.text
        if phone == nil || cellPhone == nil{
            return
        }

        if let data  = UIImagePNGRepresentation(image){
            let imageName = "shop_\(FirebaseServices.shared().userId() ?? String.randomString(length: 32))"
            showLoadingView()
            ProductServices.shared().uploadImage(data, name: imageName) { (success, message, url) in
                let shop  = PetShop()
                
                shop.shopName = name
                shop.address = address
                shop.phone = phone ?? ""
                shop.cellPhone = cellPhone ?? ""
                shop.cityId = self.cityId
                shop.description = description
                shop.imagePath = url?.absoluteString ?? ""
                ProductServices.shared().openShop(shop, complete: {[weak self] (success, message, shop) in
                    guard let strongSelf = self else{return}
                    strongSelf.hideLoadingView()
                })
                
            }
        }
        
    }
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Hà nội", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.cityId = 1
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Hồ Chí Minh", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.cityId = 2
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Bỏ qua", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
}
