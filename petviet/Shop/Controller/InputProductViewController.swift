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
    @IBOutlet weak var thumb1ImageView: UIImageView!
    @IBOutlet weak var thumb2ImageView: UIImageView!
    @IBOutlet weak var thumb3ImageView: UIImageView!
    
    
    @IBOutlet weak var productCodeTextfield: UITextField!
    @IBOutlet weak var productNameTextfield: UITextField!
    @IBOutlet weak var productPriceTextfield: UITextField!
    @IBOutlet weak var productMaxpriceTextfield: UITextField!
    @IBOutlet weak var ageTextfied: UITextField!
    @IBOutlet weak var productDescriptionTextview: UITextView!
    @IBOutlet weak var descriptionHolderTextLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var shopNameLabel: UILabel!
    
    @IBOutlet weak var selectShopButton: UIButton!
    
    @IBOutlet weak var petInfoView: UIView!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var genderButton: UIButton!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var genderTitleLabel: UILabel!
    @IBOutlet weak var colorTitleLabel: UILabel!
    @IBOutlet weak var ageTitleLabel: UILabel!
    @IBOutlet weak var ageUnitLabel: UILabel!
    
    //
    @IBOutlet weak var petInfoHeightConstraint: NSLayoutConstraint!
    
    var productType:ProductType!
    var pet:Pet!
    var productCode:String!
    var shops:[PetShop] = []
    var shop:PetShop?
    var gender:PetGender = .female
    var color:PetColor = .black
    var productImages:[UIImage] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        initLoadingView()
        setupUI()
        addTapGesture()
        fetchShop()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = "\(pet.name) - \(productType.typeName)"
        productCode =  "pet_\(pet.type)_\(productType.id)_\(String.randomString(length: 6))"
        productCodeTextfield.text = productCode
        genderLabel.text = gender.description
        colorLabel.text = color.description
        
        if productType.id != 0 || true{
            petInfoView.isHidden = true
            petInfoHeightConstraint.constant = 0
            hidePetInfoView()
            self.view.updateConstraintsIfNeeded()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        productDescriptionTextview.addBorder(2, 1, .lightGray)
    }
    func updateProductImageViews(){
        if productImages.count > 0{
            productImageView.image = productImages[0]
        }
        for i in 0..<productImages.count{
            switch i{
            case 0:
                thumb1ImageView.image = productImages[i]
                break
            case 1:
                thumb2ImageView.image = productImages[i]
                break
            case 2:
                thumb3ImageView.image = productImages[i]
                break
            default:
                break
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchShop(){
        ProductServices.shared().fetchShops { (shops) in
            self.shops = shops
        }
    }
    
    func resetInput(){
        productCode =  "pet_\(pet.type)_\(productType.id)_\(String.randomString(length: 6))"
        productCodeTextfield.text = productCode
        productNameTextfield.text = nil
        productPriceTextfield.text = nil
        productImages = []
        let noImage = UIImage(named: "ic_noimage")
        productImageView.image = noImage
        thumb1ImageView.image = noImage
        thumb2ImageView.image = noImage
        thumb3ImageView.image = noImage

        productDescriptionTextview.text = ""
    }
    
    func hidePetInfoView(){
        colorTitleLabel.isHidden = true
        colorLabel.isHidden = true
        colorButton.isHidden = true
        //
        genderTitleLabel.isHidden = true
        genderLabel.isHidden = true
        genderButton.isHidden = true
        //
        ageTitleLabel.isHidden = true
        ageTextfied.isHidden = true
        ageUnitLabel.isHidden = true
    }
    override func tappedGesture(_ gesture: UIGestureRecognizer) {
        self.view.endEditing(true)
    }
    @IBAction func tappedGenderButton(_ sender: Any) {
        let genderSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let maleAction = UIAlertAction(title: "Đực", style: .default) { (action) in
            self.gender = .male
        }
        let femaleAction = UIAlertAction(title: "Cái", style: .default) { (action) in
            self.gender = .female
        }
        
        let cancelAction = UIAlertAction(title: "Bỏ qua", style: .cancel) { (action) in
            
        }
        
        genderSheet.addAction(maleAction)
        genderSheet.addAction(femaleAction)
        genderSheet.addAction(cancelAction)
        present(genderSheet, animated: true, completion: nil)
    }
    
    @IBAction func tappedColorButton(_ sender: Any) {
        let colorSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let blackAction = UIAlertAction(title: "Đen", style: .default) { (action) in
            self.color = .black
        }
        let whiteAction = UIAlertAction(title: "Trắng", style: .default) { (action) in
            self.color = .white
        }
        let yellowAction = UIAlertAction(title: "Vàng mơ", style: .default) { (action) in
            self.color = .yellow
        }
        let brownAction = UIAlertAction(title: "Nâu đỏ", style: .default) { (action) in
            self.color = .brown
        }
        let otherAction = UIAlertAction(title: "Màu khác", style: .default) { (action) in
            self.color = .other
        }
        let cancelAction = UIAlertAction(title: "Bỏ qua", style: .cancel) { (action) in
            
        }
        
        colorSheet.addAction(blackAction)
        colorSheet.addAction(whiteAction)
        colorSheet.addAction(yellowAction)
        colorSheet.addAction(brownAction)
        colorSheet.addAction(otherAction)
        colorSheet.addAction(cancelAction)
        present(colorSheet, animated: true, completion: nil)
    }
    
    @IBAction func tappedSelectShopButton(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        for i in 0..<shops.count{
            let shop = shops[i]
            let action = UIAlertAction(title: shop.shopName, style: .default) { (action) in
                self.shop = shop
                self.shopNameLabel.text = shop.shopName
            }
            
            actionSheet.addAction(action)
        }
        present(actionSheet, animated: true, completion: nil)
    }
    @IBAction func tappedIUploadButton(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            /* get your image here */
            self.productImageView.image =  image
            self.productImages.insert(image, at: 0)
            self.updateProductImageViews()
        }
    }
    @IBAction func tappedSaveButton(_ sender: Any) {
        guard let code = productCodeTextfield.text else{return}
        guard let name = productNameTextfield.text else{return}
        guard let price = productPriceTextfield.text else{return}
        guard let maxPrice = productMaxpriceTextfield.text else{return}
        guard let description = productDescriptionTextview.text, description.count > 0 else{return}
        if productImages.count == 0{
            return
        }
        guard let shop = shop else {return}
        let age = ageTextfied.text ?? "0"

        let product = PetProduct(catId: productType.id,petId:pet.type, productCode: code, productName: name, price: Float(price) ?? 0.0, maxPrice:Float(maxPrice) ?? 0.0,age:Int(age) ?? 0, gender:gender.rawValue,color:color.rawValue, imagePath:[],description:description)
        
        var datas:[Data] = []
        for image in productImages{
            if let data = UIImagePNGRepresentation(image){
                datas.append(data)
            }
        }
   
        let prefixName = "pet_\(pet.type)_\(productType.id)"
        showLoadingView()
        ProductServices.shared().uploadImages(datas, prefixName) { (urls) in
            product.imagePath =  urls
            ProductServices.shared().addProduct(product,shop) {[weak self] (success, message, key) in
                guard let strongSelf = self else{return}
                strongSelf.hideLoadingView()
                if success{
                    strongSelf.resetInput()
                }
            }
        }
        
        
    }

    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
extension InputProductViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if let text = textView.text, text.count > 0{
            descriptionHolderTextLabel.isHidden = true
        }else{
            descriptionHolderTextLabel.isHidden = false

        }
    }
}
