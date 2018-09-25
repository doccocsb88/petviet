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
    @IBOutlet weak var followerButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    var userId:String?
    var posts:[PostDetail] = []
    var currentUserId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
                        
                    }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell", for: indexPath) as! HomeViewCell
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
