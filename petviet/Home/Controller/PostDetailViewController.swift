//
//  PostDetailViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Kingfisher
import youtube_ios_player_helper_swift
class PostDetailViewController: BaseViewController {

    @IBOutlet weak var avatarButton: UIButton!
    
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var storyLabel: UILabel!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var storyImageView: UIImageView!
    
    @IBOutlet weak var playerView: YTPlayerView!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var commentTextview: UITextView!
    @IBOutlet weak var commentPlaceholderLabel: UILabel!
    @IBOutlet weak var sendCommentButton: UIButton!
    
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentBoxBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    var postDetail:PostDetail!
    var didUpdatePostValue:()->() = {}
    var willComment:Bool = false
    var answerTo:PetComment?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        if firstTime {
            firstTime = false
            bindData()
        }
        if willComment{
            commentTextview.becomeFirstResponder()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        tableView.register(UINib(nibName: "CommentViewCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        commentTextview.contentInset = UIEdgeInsetsMake(0, 10, 0, 10)
        commentTextview.autocorrectionType = .no

        commentTextview.addBorder(15, 0.5,.lightGray)
        commentTextview.delegate = self
        sendCommentButton.addBorder(4, 0.5,.lightGray)
        
        //
        likeButton.imageView?.contentMode = .scaleAspectFit
        commentButton.imageView?.contentMode = .scaleAspectFit
        playerView.delegate = self
    }
    func bindData(){
        if let userId = FirebaseServices.shared().userId(){
            likeButton.isSelected = postDetail.isLiked(userId)
        }
        createdDateLabel.text = postDetail.caculateTimeToNow()
        displayNameLabel.text = postDetail.userName
        storyLabel.text = postDetail.story
        commentButton.setTitle("\(postDetail.comments.count)", for: .normal)
        if postDetail.storyType == StoryType.image.rawValue{
            if let imagePath = postDetail.imagePath, imagePath.verifyUrl() == true{
                storyImageView.kf.setImage(with: URL(string: imagePath))
            }
            self.playerView.isHidden = true
            self.storyImageView.isHidden = false
            self.thumbnailHeightConstraint.constant = UIScreen.main.bounds.width
        }else if postDetail.storyType == StoryType.youtube.rawValue{
            if let youtubeId = postDetail.getYutubeId(){
                let _ = self.playerView .load(videoId: youtubeId)
            }
            self.playerView.isHidden = false
            self.storyImageView.isHidden = true
            self.thumbnailHeightConstraint.constant = (UIScreen.main.bounds.width / 16) * 9

        }
        self.view.updateConstraintsIfNeeded()
    }
    @objc func keyboardWillAppear(_ notification: Notification) {
        //Do something here
        adjustKeyboardShow(true, notification: notification)
        
    }
    
    @objc func keyboardWillDisappear(_ notification: Notification) {
        //Do something here
        adjustKeyboardShow(false, notification: notification)
    }
    func adjustKeyboardShow(_ open: Bool, notification: Notification) {
        let userInfo = notification.userInfo ?? [:]
        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let height = (keyboardFrame.height) * (open ? 1 : 0)
        var bottomPadding:CGFloat = 0
        if open{
            self.commentBoxBottomConstraint.constant = 0 - height
            bottomPadding = height + commentContainerView.frame.height
        }else{
            self.commentBoxBottomConstraint.constant = self.commentContainerView.frame.size.height
            bottomPadding = 0
            
        }
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, bottomPadding, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;

        UIView.animate(withDuration: 0.25) {
           self.view.updateConstraintsIfNeeded()
        }
    }
    

    @IBAction func tappedBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedLikeButton(_ sender: Any) {
        
        if let key = postDetail.userLikedKey(FirebaseServices.shared().userId()){
            FirebaseServices.shared().unLikePost(key, postDetail.key) { [unowned self](success, message, like) in
                if success{
                    self.postDetail.unLike(FirebaseServices.shared().userId())
                    self.bindData()
                    self.didUpdatePostValue()
                }
            }
        }else{
            FirebaseServices.shared().likePost(postDetail.key) { [unowned self](success, message, userLiked) in
                if success{
                    self.postDetail.doLike(userLiked)
                    self.bindData()
                    self.didUpdatePostValue()

                }
            }
        }
    }
    
    
    @IBAction func tappedShareButton(_ sender: Any) {
        
    }
    @IBAction func tappedCommentButton(_ sender: Any) {
        commentTextview.becomeFirstResponder()
    }
    
    @IBAction func tappedProfileButton(_ sender: Any) {
    }
    @IBAction func tappedSendButton(_ sender: Any) {
        guard let user = FirebaseServices.shared().currentUser() else {return}
        guard let message = commentTextview.text, message.count > 0 else{return}
        commentTextview.text = ""
        commentTextview .resignFirstResponder()
        
        let petComment = PetComment(message)
        petComment.userDisplayName = user.displayName ?? user.uid
        
        if let toUser = self.answerTo{
            let data:[String:String] = ["userId":toUser.userId,"displayName":toUser.userDisplayName]
            petComment.to_user = Utils.convertToJSON(data)
        }
        FirebaseServices.shared().commentPost(petComment, postDetail.key) {[unowned self] (success, message, comment) in
            if success == true , let comment = comment{
                self.postDetail.addComment(comment)
                self.didUpdatePostValue()
                self.tableView.reloadData()
            }else{
                
            }
        }
    }
}
extension PostDetailViewController{
    
}
extension PostDetailViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postDetail.comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentViewCell
        let comment = postDetail.comments[indexPath.row]
        cell.updateContent(comment)
        cell.didTappedAnswer = { [unowned self ] in
            self.answerTo = comment
            self.commentTextview.becomeFirstResponder()
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension PostDetailViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        commentPlaceholderLabel.isHidden = textView.text.count > 0

    }
    func textViewDidEndEditing(_ textView: UITextView) {
         commentPlaceholderLabel.isHidden = textView.text.count > 0
    }
}
extension PostDetailViewController:YTPlayerViewDelegate{
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        
    }
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        
    }
}
