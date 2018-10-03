//
//  ProductDetailViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/27/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Kingfisher
class ProductDetailViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var addressImageView: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var productDescriptionLabel: UILabel!
    var product:PetProduct?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addDefaultLeft()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if firstTime{
            firstTime = false
            bindData()
            fetchShopInfo()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        phoneImageView.contentMode = .scaleAspectFit
        addressImageView.imageView?.contentMode = .scaleAspectFit
        
    }
   
    func bindData(){
        guard let product = product else{return}
        
        self.navigationItem.title = product.productName
        if product.imagePath.count > 0{
            let path = product.imagePath[0]
            let url = URL(string: path)
            productImageView.kf.setImage(with: url)
        }else{
            productImageView.image = UIImage(named: "ic_noimage")
        }
        
        productNameLabel.text = product.productName
        priceLabel.text = "\(product.price)"
        
        productDescriptionLabel.text = product.description
        
    }
    
    func fetchShopInfo(){
        guard let product = product else{return}
        guard let shop = product.shops else{return}
        ProductServices.shared().fetchShop(shop) { [weak self](shop) in
            guard let shop = shop else {return}
            guard let strongSelf = self else{return}
            strongSelf.phoneLabel.setTitle(shop.phone, for: .normal)
            strongSelf.addressLabel.text = shop.address
        }
    }
    override func tappedLeftButton(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedPhoneNumberButton(_ sender: Any) {
        guard let phoneNumber = phoneLabel.titleLabel?.text, phoneNumber.isPhone() else {return}
        self.callNumber(phoneNumber: phoneNumber)
    }
    
}
