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
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageScrollview: UIScrollView!
    @IBOutlet weak var phoneImageView: UIImageView!
    @IBOutlet weak var addressImageView: UIButton!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var phoneLabel: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!

    @IBOutlet weak var productDescriptionLabel: UILabel!
    var product:PetProduct?
    var shop:PetShop?
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
        imageScrollview.delegate = self
    }
   
    func bindData(){
        guard let product = product else{return}
        
        self.navigationItem.title = product.productName
        let slides = createSlides()
        let size = UIScreen.main.bounds.width
        imageScrollview.contentSize = CGSize(width: size * CGFloat(slides.count), height: size)
        imageScrollview.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: size * CGFloat(i), y: 0, width: size, height: size)
            imageScrollview.addSubview(slides[i])
        }
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        containerView.bringSubview(toFront: pageControl)
        //
        
        productNameLabel.text = product.productName
        

        priceLabel.text = String(format: "%@ - %@",product.price.formattedNumber(),product.maxPrice.formattedNumber())
        
        productDescriptionLabel.text = product.description
        
    }
    func createSlides() -> [SlideView] {
        var slides:[SlideView] = []
        guard let product = product else{return slides}

        if product.imagePath.count > 0{
            for imagepath in product.imagePath{
//                let path = product.imagePath[0]
                let url = URL(string: imagepath)
                let slide:SlideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
                slide.imageView.kf.setImage(with: url)
                slides.append(slide)
                
            }
        }else{
            let slide:SlideView = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! SlideView
            slide.imageView.image = UIImage(named: "ic_noimage")
            slides.append(slide)
        }
        
        return slides
        
    }
    func fetchShopInfo(){
        guard let product = product else{return}
        guard let shop = product.shops else{return}
        ProductServices.shared().fetchShop(shop) { [weak self](shop) in
            guard let shop = shop else {return}
            guard let strongSelf = self else{return}
            strongSelf.shop = shop
            if shop.phone.count > 0{
                strongSelf.phoneLabel.setTitle(shop.phone, for: .normal)
            }else if shop.cellPhone.count > 0{
                strongSelf.phoneLabel.setTitle(shop.cellPhone, for: .normal)
            }
            strongSelf.addressLabel.text = shop.address
        }
    }
    override func tappedLeftButton(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func tappedPhoneNumberButton(_ sender: Any) {
        guard let phoneNumber = phoneLabel.titleLabel?.text, phoneNumber.isPhone() else {return}
        self.callNumber(phoneNumber: phoneNumber)
        if let shop = shop{
            print("countCall 1:  \(shop.countCall)")
            ProductServices.shared().increaseShopCalled(shop) { (success, message) in
                print("countCall 2: \(shop.countCall)")

            }
        }
    }
    
}

extension ProductDetailViewController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
//        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
//        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
//
//        // vertical
//        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
//        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
//
//        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
//        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
    }
}
