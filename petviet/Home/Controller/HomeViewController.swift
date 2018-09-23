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
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        FirebaseServices.shared().createUser("amail@gmail.com", "123456", "anh dep trai") { (success, message) in
//            
//        }
        FirebaseServices.shared().loginWithEmailPassword("amail@gmail.com", "123456") { (success, mmessage) in
            
        }
        initNavigation()
        setupUI()
        fetchPosts()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initNavigation(){
        self.addRightButton(UIImage(named: "ic_tab_service"))
        
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
        FirebaseServices.shared().fetchPosts(1) { [weak self](success, nil, posts) in
            guard let strongSelf = self else{return}
            strongSelf.posts = posts
            strongSelf.tableView.reloadData()
        }
    }
    func showPostDetailView(){
        let vc = PostDetailViewController(nibName: "PostDetailViewController", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showPostDetailView()
    }
}
