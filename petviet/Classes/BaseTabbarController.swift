//
//  BaseTabbarController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import UIKit
class BaseTabbarController: UITabBarController {
    static let titles:[String] = ["Pet Viet", "Dịch vụ", "Cửa hàng", "Thông tin cá nhân"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setup(){
        self.view.backgroundColor = UIColor.white
        //        let icons : [String] = ["ic_tab_home","ic_tab_setup","ic_tab_camera","ic_tab_profile"]
        let icons : [String] = ["ic_tab_home","ic_tab_service","ic_tab_shop","ic_tab_profile"]
        
        if let items = tabBar.items {
            for i in 0 ..< items.count {
                let item = items[i]
                
                setupItem(item: item, imageName: icons[i])
                
            }
        }
        
        self.tabBar.tintColor = .orange
        self.tabBar.barTintColor = .white

    }
    
    func setupItem(item: UITabBarItem, imageName: String){
        let originImage  = UIImage(named: imageName)
        let itemImage = originImage?.imageWithColor(color1: UIColor.lightGray).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        let tintedImage  = originImage?.imageWithColor(color1: UIColor(hexString: "#FC6076")).withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        item.image = itemImage
        item.selectedImage = tintedImage//imageWithColor(color1: UIColor(hexString: "#FC6076"))
        item.title = nil
        item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        
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
