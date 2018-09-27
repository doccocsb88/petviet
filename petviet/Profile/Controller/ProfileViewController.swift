//
//  ShopViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    
    @IBOutlet weak var bioLabel: UILabel!
    
    @IBOutlet weak var storyButton: UIButton!
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userId:String?
    var posts:[PostDetail] = []
    var currentUserId:String?
    var profile:PetProfile?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        if firstTime {
            firstTime = false
            if let userId = self.userId{
                self.currentUserId = userId
               
            }else if let userId = FirebaseServices.shared().userId(){
                self.currentUserId = userId
            }
            if let userId = self.currentUserId{
                FirebaseServices.shared().fetchPostByUserId(userId) {  [weak self](success, message, posts) in
                    guard let strongSelf = self else {return}
                    if success{
                        strongSelf.posts = posts
                        strongSelf.tableView.reloadData()
                        strongSelf.storyButton.setTitle("\(posts.count) \n stories", for: .normal)
                        
                    }
                }
                //
                FirebaseServices.shared().fetchProfile(userId) { [weak self](success, profile) in
                       guard let strongSelf = self else {return}
                        strongSelf.profile = profile
                        strongSelf.bindData()
                }
            }
           
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        self.title = BaseTabbarController.titles[3]
        let avatarSize = avatarImageView.frame.height
        avatarImageView.addBorder(avatarSize / 2, 1, .lightGray)
        
        //
        tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "homeCell")
    }

    func bindData(){
        if let profile = profile{
            self.bioLabel.text = profile.biography
            self.displayNameLabel.text = profile.displayName
            self.followerButton.setTitle(" \(profile.followers().count)\n followers", for: .normal)
            self.followingButton.setTitle(" \(profile.following().count)\n following", for: .normal)
        }
        
    }
    func showFollowView(_ follows:[PetFollow], _ following:Bool){
        let vc = FollowViewController(nibName: "FollowViewController", bundle: nil)
        vc.follows = follows
        vc.following = following
        vc.didUploadFollow = { [weak self] in
            guard let strongSelf = self else{return}
            strongSelf.bindData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tappedBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func tappedFollowerButton(_ sender: Any) {
    
        
        showFollowView(DataServices.shared().profile.following(), false)

    }
    @IBAction func tappedFollowingButton(_ sender: Any) {
        showFollowView(DataServices.shared().profile.following(), true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! PetStoryViewCell
        let post = posts[indexPath.row]
        cell.updateContent(post)
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        self.showPostDetailView(post,false)
    }
}
