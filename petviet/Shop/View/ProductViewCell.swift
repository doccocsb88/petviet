//
//  ProductViewCell.swift
//  petviet
//
//  Created by Hai Vu on 9/27/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Kingfisher
class ProductViewCell: UICollectionViewCell {

    @IBOutlet weak var productImageImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productPriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func updateContent(_ product:PetProduct){
        productPriceLabel.text = "\(product.price)"
        productNameLabel.text = product.productName
        
        if product.imagePath.count > 0{
            let path = product.imagePath[0]
            let url = URL(string: path)
            productImageImageView.kf.setImage(with: url)
            
        }else{
            productImageImageView.image = UIImage(named: "ic_noimage")
        }
    }
}
