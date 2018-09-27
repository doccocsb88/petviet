//
//  StoryCategoryViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/25/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class PetSpeciesViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func updateContent(_ pet:Pet, _ isSelected:Bool){
        nameLabel.text = pet.name
        if isSelected {
            self.contentView.addBorder(0, 2, .blue)
        }else{
            self.contentView.addBorder(0, 0, .clear)

        }
    }
}
