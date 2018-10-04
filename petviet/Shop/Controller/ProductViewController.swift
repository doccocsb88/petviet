//
//  ProductViewController.swift
//  petviet
//
//  Created by Hai Vu on 9/27/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class ProductViewController: BaseViewController {
    fileprivate let itemsPerRow: CGFloat = 2
    fileprivate let sectionInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)

    @IBOutlet weak var collectionView: UICollectionView!
    var products:[PetProduct] = []
    var type:ProductType!
    var pet:Pet!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addRightButton(UIImage(named: "ic_tab_service"))
        addDefaultLeft()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "\(type.typeName) - \(pet.name)"
        if type.id == 0{
            ProductServices.shared().fetchPets(pet) {[weak self] (products)in
                guard let strongSelf = self else{return}
                strongSelf.products = products
                strongSelf.collectionView.reloadData()
            }
        }else{
            ProductServices.shared().fetchProducts(pet, type) {[weak self] (products) in
                guard let strongSelf = self else{return}
                strongSelf.products = products
                strongSelf.collectionView.reloadData()
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        collectionView.register(UINib(nibName: "ProductViewCell", bundle: nil), forCellWithReuseIdentifier: "productCell")
        collectionView.contentInset = sectionInsets
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func tappedRightButton(_ button: UIButton) {
        let vc = InputProductViewController(nibName: "InputProductViewController", bundle: nil)
        vc.productType = type
        vc.pet = pet
        present(vc, animated: true, completion: nil)
    }
    override func tappedLeftButton(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    func showProductDetailView(_ product:PetProduct){
        let vc = ProductDetailViewController(nibName: "ProductDetailViewController", bundle: nil)
        vc.product = product
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductViewCell
        let product = products[indexPath.row]
        cell.updateContent(product)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = products[indexPath.row]
        self.showProductDetailView(product)
    }

}

extension ProductViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem + 60)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
