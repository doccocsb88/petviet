//
//  BaseViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Lottie

class BaseViewController: UIViewController {
    var leftButton:UIButton?
    var rightButton:UIButton?
    var firstTime:Bool = true
    var loadingAnimation: LOTAnimationView?

    override func viewDidLoad() {
        super.viewDidLoad()
        let image = UIImage(color: .white)
        self.navigationController?.navigationBar.setBackgroundImage(image,for: .default)
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
   
    func initLoadingView(){
        loadingAnimation = LOTAnimationView(name:  "material_loader")
        // Set view to full screen, aspectFill
        loadingAnimation!.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        loadingAnimation!.contentMode = .scaleAspectFill
        loadingAnimation!.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingAnimation!.center = self.view.center
        loadingAnimation!.isHidden = true
        loadingAnimation!.loopAnimation = true
        // Add the Animation
        view.addSubview(loadingAnimation!)
        
    }
    
    func showMessageDialog(_ title:String?, _ message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Đồng ý", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func showLoadingView(){
        if let _ = self.loadingAnimation {
            self.loadingAnimation!.isHidden = false
            self.loadingAnimation!.play()
            
        }
        
    }
    func hideLoadingView(){
        if let _ = self.loadingAnimation{
            self.loadingAnimation!.isHidden = true
            self.loadingAnimation!.stop()
        }
        
    }
    func showPostDetailView(_ post:PostDetail, _ willComment:Bool){
        let vc = PostDetailViewController(nibName: "PostDetailViewController", bundle: nil)
        vc.postDetail = post
        vc.willComment = willComment
        
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func showProfileView(_ userId:String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "profileViewController") as? ProfileViewController{
            vc.userId = userId
//            vc.modalPresentationStyle = .overFullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }

}
