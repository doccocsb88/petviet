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
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    var didSelectImage:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    func setupUI(){
        selectButton.addBorder(10, 0.5, .white)
    }
    func updateContent(_ image:UIImage?, _ isSelected:Bool){
        thumbnailImageView.image = image
        selectButton.isSelected = isSelected
    }
    @IBAction func tappedSelectImage(_ sender: Any) {
        didSelectImage()
    }
}
