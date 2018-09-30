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
    
    
    @IBOutlet weak var followUserButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var shopButton: UIButton!
    
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
                if DataServices.shared().isFollowed(userId){
                    self.followUserButton.setTitle("Bỏ theo dõi", for: .normal)

                }else{
                    self.followUserButton.setTitle("Theo dõi", for: .normal)
                }
                self.followUserButton.isHidden = false

            }else if let userId = FirebaseServices.shared().userId(){
                self.currentUserId = userId
                self.followUserButton.isHidden = true
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
    
        if self.currentUserId == DataServices.shared().profile.userId{

            showFollowView(DataServices.shared().profile.following(), false)
        }

    }
    @IBAction func tappedShopButton(_ sender: Any) {
        
        let vc = RegisterShopViewController(nibName: "RegisterShopViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func tappedFollowingButton(_ sender: Any) {
        if self.currentUserId == DataServices.shared().profile.userId{
        
            showFollowView(DataServices.shared().profile.following(), true)
        }
    }
    
    @IBAction func tappedFollowUserButton(_ sender: Any) {
        guard let profile = self.profile else{return}
        if let userId = self.userId{
            let isFollow = DataServices.shared().isFollowed(userId)
            if isFollow{
                FirebaseServices.shared().unfollow(userId) { [weak self] (success, message) in
                    guard let strongSelf = self else{return}

                    if success{
                        DataServices.shared().unFollowUser(userId)
                        strongSelf.bindData()
                    }
                }
            }else{
                FirebaseServices.shared().follow(profile.userId, profile.displayName) {[weak self] (success, message) in
                    guard let strongSelf = self else{return}
                    if success{
                        strongSelf.bindData()
                    }
                }
            }
        }
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
