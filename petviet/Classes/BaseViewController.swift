//
//  BaseViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var leftButton:UIButton?
    var rightButton:UIButton?
    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(color: .white)
        self.navigationController?.navigationBar.setBackgroundImage(image,for: .default)
        let tapped = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        self.view.addGestureRecognizer(tapped)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addRightButton(_ image:UIImage?){
        rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        rightButton?.imageView?.contentMode = .scaleAspectFit
        rightButton?.setImage(image, for: .normal)
        rightButton?.addTarget(self, action: #selector(tappedRightButton(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: rightButton!)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    func addLeftButton(_ image:UIImage?){
        leftButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        leftButton?.imageView?.contentMode = .scaleAspectFit
        leftButton?.setImage(image, for: .normal)
        leftButton?.addTarget(self, action: #selector(tappedLeftButton(_:)), for: .touchUpInside)
        let rightItem = UIBarButtonItem(customView: leftButton!)
        self.navigationItem.leftBarButtonItem = rightItem
    }
    @objc func tappedRightButton(_ button:UIButton){
        
    }
    @objc func tappedLeftButton(_ button:UIButton){
        
    }
    @objc func tappedGesture(_ gesture:UIGestureRecognizer){
        self.view.endEditing(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
