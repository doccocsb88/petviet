//
//  ProductViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class ProductCategoryViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateContent(_ type:ProductType, _ isSelected:Bool){
        nameLabel.text = type.typeName
        if isSelected {
            nameLabel.textColor = .red
        }else{
            nameLabel.textColor = .black
        }
    }
    

}
