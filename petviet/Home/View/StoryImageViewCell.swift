//
//  StoryImageViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class StoryImageViewCell: UICollectionViewCell {

    @IBOutlet weak var selectButton: UIButton!
    
    @IBOutlet weak var thumbnailImageView: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    func setupUI(){
        selectButton.addBorder(10, 0.5, .white)
    }
}
