//
//  HomeViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var posts:[PostDetail] = []
    var currentPostIndex:IndexPath?
    var pet:Pet?
    override func viewDidLoad() {
        super.viewDidLoad()

        let email = "cmail@gmail.com";
        let password = "123456"
        let displayName = "userC"
//        FirebaseServices.shared().createUser(email, password, displayName) { (success, message) in
//
//        }
        FirebaseServices.shared().loginWithEmailPassword(email, password) { (success, mmessage) in

        }
//        FirebaseServices.shared().logout()
        FirebaseServices.shared().fetchProfile {
            self.tableView.reloadData()
        }
        initNavigation()
        initLoadingView()
        setupUI()
        fetchPosts()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.currentPostIndex = nil
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initNavigation(){
        self.addRightButton(UIImage(named: "ic_tab_service"))
        self.addLeftButton(UIImage(named: "ic_filter"))
        
    }
    func setupUI(){
        self.title = BaseTabbarController.titles[0]
        tableView.register(UINib(nibName: "HomeViewCell", bundle: nil), forCellReuseIdentifier: "homeViewCell")
        
    }
    override func tappedRightButton(_ button: UIButton) {
        let vc = PublishStoryViewController(nibName: "PublishStoryViewController", bundle: nil)
        vc.modalPresentationStyle  = .overFullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.didPublishStory = {
            self.fetchPosts()
            self.dismiss(animated: true, completion: nil)
        }
        present(vc, animated: true, completion: nil)
    }
    override func tappedLeftButton(_ button: UIButton) {
        let vc = StoryCategoryViewController(nibName: "StoryCategoryViewController", bundle: nil)
        vc.modalPresentationStyle  = .overCurrentContext
        vc.isFilterPost = true
        vc.didFilterPost = {[weak self]pet in
            guard let strongSelf = self else {return}
            if strongSelf.pet?.type ?? 0 != pet?.type ?? 0{
                strongSelf.pet = pet
                strongSelf.fetchPosts()
            }
            strongSelf.dismiss(animated: true, completion: nil)

        }
        present(vc, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchPosts(){
        showLoadingView()
        FirebaseServices.shared().fetchPosts(pet?.type ?? 0) { [weak self](success, nil, posts) in
            guard let strongSelf = self else{return}
            strongSelf.hideLoadingView()
            strongSelf.posts = posts
            strongSelf.tableView.setContentOffset(.zero, animated: true)
            strongSelf.tableView.reloadData()
        }
    }
    override func showPostDetailView(_ post:PostDetail, _ willComment:Bool){
        let vc = PostDetailViewController(nibName: "PostDetailViewController", bundle: nil)
        vc.postDetail = post
        vc.willComment = willComment
        vc.didUpdatePostValue = { [weak self] in
            guard let strongSelf = self else{return}
            if let indexPath = strongSelf.currentPostIndex{
                strongSelf.tableView.beginUpdates()
                strongSelf.tableView.reloadRows(at: [indexPath], with: .none)
                strongSelf.tableView.endUpdates()
            }
        }
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return posts.count
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeViewCell", for: indexPath) as! HomeViewCell
        let post = posts[indexPath.row]
        cell.updateContent(post)
        cell.didTappedLike = {
            if let userId = FirebaseServices.shared().userId(){
                if let key = post.userLikedKey(userId){
                    FirebaseServices.shared().unLikePost(key, post.key, complete: { (success, message, isLiked) in
                        NSLog("unLike %d", success)
                        if success{
                            post.unLike(userId)
                            cell.updateContent(post)
                        }
                    })
                }else{
                    FirebaseServices.shared().likePost(post.key, complete: { (success, message, userLike) in
                        NSLog("Like %d", success)
                        if success == true, let userLike = userLike{
                            post.doLike(userLike)
                            cell.updateContent(post)
                        }else{
                            
                        }
                    })
                }
            }
        }
        cell.didTappedComment = { [unowned self] in
            self.currentPostIndex = indexPath
            self.showPostDetailView(post,true)
        }
        cell.didTapUserProfile = {
            self.showProfileView(post.created_user)
        }
        cell.didTapFollowButton = {
            
            FirebaseServices.shared().follow(post.created_user, post.userName, complete: {[weak self] (success, message) in
                guard let strongSelf = self else {return}
                if success{
                    strongSelf.tableView.reloadData()
                }
            })
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = posts[indexPath.row]
        self.currentPostIndex = indexPath
        self.showPostDetailView(post,false)
    }
}
