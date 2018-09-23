//
//  StoryCameraViewCell.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class StoryCameraViewCell: UICollectionViewCell {

    @IBOutlet weak var cameraButton: UIButton!
    var didSelectCamera:()->() = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func tappedCameraButton(_ sender: Any) {
        didSelectCamera()
    }
}
