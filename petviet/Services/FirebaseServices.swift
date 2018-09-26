//
//  FirebaseServices.swift
//  petviet
//
//  Created by Macintosh HD on 9/23/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
class FirebaseServices{
    fileprivate let PATH_PROFILE = "users"
    fileprivate let PATH_FOLLOW = "follows"

    fileprivate let PATH_POST = "posts"
    fileprivate let PATH_POST_LIKE = "likes"
    fileprivate let PATH_POST_COMMENT = "comments"

    fileprivate let PATH_USER = "uers"
    var ref: DatabaseReference!
    
    static let sharedInstance : FirebaseServices = {
        let instance = FirebaseServices()
        return instance
    }()
    
    
    init(){
        ref = Database.database().reference()

    }
    class func shared() -> FirebaseServices {
        return sharedInstance
    }
    func userId()->String?{
        guard let user = Auth.auth().currentUser else {return nil}
        return user.uid
    }
    func currentUser() -> User?{
        return Auth.auth().currentUser
    }
    func loginWithEmailPassword(_ email:String, _ password: String, onSuccess
        success: @escaping (_ success:Bool, _ message:String?) -> Void){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            // ...
            if let error = error{
                NSLog("error %ld", error._code)
                if error._code == 17009{
                    success(false,"Mật khẩu không hợp lệ")
                    
                }else if (error._code == 17011){
                    success(false,"Tài khoản không tồn tại")
                    
                }else{
                    success(false,error.localizedDescription)
                }
            }else{
                success(true,nil)
            }
        }
        
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch{
            
        }
    }
    
    func createUser(_ email:String, _ password: String, _ fullname: String, onSuccess
        success: @escaping (_ success:Bool, _ message:String?) -> Void){
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            guard let _ = authResult?.user else {
                success(false, error?.localizedDescription)
                return
                
            }
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = fullname
            changeRequest?.commitChanges(completion: { (error) in
                success(true, nil)
                
            })
            
        }
    }
    func createProfile(){
        guard let user = Auth.auth().currentUser else{return}
        let profileRef = ref.child(PATH_PROFILE).child(user.uid);
        let profile:[String:Any?] = ["email":user.email,"displayName":user.displayName]
        profileRef.setValue(profile) { (error, dataRef) in
            
        }
    }
    func fetchProfile(complete:@escaping()->Void){
        guard let user = Auth.auth().currentUser else{return}
       
        
        fetchProfile(user.uid) { (success, profile) in
            DataServices.shared().profile = profile
            complete()
        }
    }
    
    func fetchProfile(_ userId:String, complete:@escaping(_ success:Bool, _ profile:PetProfile)->Void){
        let profileRef = ref.child(PATH_PROFILE).child(userId)
        let profile = PetProfile()
        profile.userId = userId
        profileRef.observeSingleEvent(of: .value) { (snapshot) in
            if let dict  = snapshot.value as? [String:Any]{
                NSLog("profile %@", Utils.convertToJSON(dict))
                if let follows = dict["follows"]  as? [String:Any]{
                    for key in follows.keys{
                        if let followDict = follows[key] as? [String:Any]{
                            if let follow = PetFollow(JSON: followDict){
                                profile.follows.append(follow)
                            }
                        }
                        
                    }
                }
                if let profileDict = dict["profile"] as? [String:Any]{
                    profile.email =  profileDict["email"] as? String ?? ""
                    profile.displayName = profileDict["displayName"] as? String ?? ""
                    profile.biography = profileDict["biography"] as? String ?? ""
                    
                }
            }
            complete(true,profile)
        }
    }
    func follow(_ toId:String, _ toName:String, complete:@escaping (_ success:Bool, _ message:String?) -> Void){
        guard let user = Auth.auth().currentUser else{return}
        let follow = PetFollow(user.uid,user.displayName ?? "", toId,toName)
        let followingPath  = "\(PATH_PROFILE)/\(follow.toId)/\(PATH_FOLLOW)"
        let followingRef = ref.child(followingPath).childByAutoId()
        
        followingRef.setValue(follow.toJSON()) { (error, dataRef) in
            
        }
        
        //
        let followPath  = "\(PATH_PROFILE)/\(follow.fromId)/\(PATH_FOLLOW)"
        let followRef = ref.child(followPath).childByAutoId()
        followRef.setValue(follow.toJSON()) { (error, dataRef) in
            if let error = error{
                complete(false, error.localizedDescription)
            }else{
                complete(true,nil)
            }
        }
    }
    func unfollow(_ follow:PetFollow, complete:@escaping (_ success:Bool, _ message:String?) -> Void){
        guard let user = Auth.auth().currentUser else{return}
        
        //
        let followPath  = "\(PATH_PROFILE)/\(user.uid)/\(PATH_FOLLOW)/\(follow.key)"
        let followRef = ref.child(followPath)
        followRef.removeValue()
        //
        let followingPath  = "\(PATH_PROFILE)/\(follow.toId)/\(PATH_FOLLOW)"
        let followingRef = ref.child(followingPath).queryOrdered(byChild: "fromId").queryEqual(toValue: user.uid)
        followingRef.observeSingleEvent(of: .value) { (snapshot) in
            
            for child in snapshot.children{
                if let dict = child as? DataSnapshot {
                    self.ref.child("\(followingPath)/\(dict.key)").removeValue()
                }
            }
            complete(true,nil)
        }
       
        
     
    }
    func publishPost(_ postDetail:PostDetail, complete:@escaping (_ success:Bool, _ message:String?) -> Void){
        let postRef = ref.child(PATH_POST);
        let child = postRef.childByAutoId()
       
        //let data:[String:[String:Any]] = [child.key:postDetail.toJSON()]
        child.setValue(postDetail.toJSON()) { (error, dataRef) in
            if let error = error{
                complete(false,error.localizedDescription)
            }else{
                complete(true,nil)
            }
        }
 
    }
    
    func fetchPosts(_ catId:Int, complete:@escaping (_ success:Bool, _ message:String?, _ posts:[PostDetail]) ->Void){
        let postRef = ref.child(PATH_POST);
        postRef.observeSingleEvent(of: .value) { (snapshot) in
            let posts = self.parsePostData(snapshot)
            complete(true,nil,posts)

        }
    }
    
    func fetchPostByUserId(_ userId:String, complete:@escaping (_ success:Bool, _ message:String?, _ posts:[PostDetail]) ->Void){
        let postRef = ref.child(PATH_POST);
        postRef.queryOrdered(byChild: "created_user").queryEqual(toValue: userId).observeSingleEvent(of: .value) { (snapshot) in
            let posts = self.parsePostData(snapshot)
            complete(true,nil,posts)
        }
    }
    
    
    func isLiked(_ postKey:String, complete:@escaping (_ success:Bool, _ message:String?, _ isLiked:Bool) ->Void){
        guard let user = Auth.auth().currentUser else {return}
        let postRef = ref.child(PATH_POST).child(postKey).queryOrdered(byChild: "likes").queryEqual(toValue: user.uid, childKey: "userid")
        postRef.observe(.value) { (snapshot) in
            
        }
    }
    func unLikePost(_ likeKey:String,_ postKey:String, complete:@escaping (_ success:Bool, _ message:String?, _ isLiked:Bool) ->Void){
        guard let _ = Auth.auth().currentUser else {return}
        
        let postRef = ref.child(PATH_POST).child(postKey).child(PATH_POST_LIKE).child(likeKey)
        postRef.removeValue { (error, dataRef) in
            if let error = error{
                complete(false,error.localizedDescription,false)

            }else{
                complete(true,nil,false)
            }
        }

    }
    func likePost(_ postKey:String, complete:@escaping (_ success:Bool, _ message:String?, _ userLike:UserLike?) ->Void){
        guard let user = Auth.auth().currentUser else {return}

        let postRef = ref.child(PATH_POST).child(postKey).child(PATH_POST_LIKE)
        let childRef = postRef.childByAutoId()
        let data:[String:Any] = ["userId":user.uid,"displayName":user.displayName ?? "Somebody"]
        childRef.setValue(data) { (error, dataRef) in
            if let error = error{
                complete(false,error.localizedDescription,nil)
            }else{
                let userLike = UserLike(JSON: data)
                userLike?.key = childRef.key!
                complete(true,nil,userLike)

            }
        }
        
    }
    func commentPost(_ comment:PetComment, _ postKey:String, complete:@escaping(_ success:Bool , _ message:String?, _ petComment:PetComment?)->Void){
        guard let user = Auth.auth().currentUser else {return}

        let postRef = ref.child(PATH_POST).child(postKey).child(PATH_POST_COMMENT)
        let childRef = postRef.childByAutoId()
        let data:[String:Any] = ["userId":user.uid,"displayName":user.displayName ?? "Somebody","message":comment.message, "created_date":comment.created_date, "to_user":comment.to_user]
        
        comment.key = childRef.key!
        comment.userId = user.uid
        comment.userDisplayName = user.displayName ?? "Somebody"
        childRef.setValue(data) { (error, dataRef) in
            if let error = error{
                complete(false,error.localizedDescription,nil)
            }else{
                complete(true,nil,comment)
            }
        }

    }
    func uploadImage(_ localFile:URL,complete:@escaping (_ success:Bool, _ message:String?, _ imageUrl:URL?)->Void){
        guard let user = Auth.auth().currentUser else{
            return
        }
        let storage = Storage.storage()
        
        let storageRef = storage.reference()
        
        
        // Create a reference to the file you want to upload
        let name = String(format: "%@.jpg",String.randomString(length: 32))
        let path = String(format: "images/%@/%@", user.uid,name)
        //        let localFile = URL(string: pathToImage)!
        
        // Create a reference to the file you want to upload
        let riversRef = storageRef.child(path)
        let metadata = StorageMetadata()
        
        metadata.contentType = "image/jpeg"
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = riversRef.putFile(from: localFile, metadata: metadata) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                NSLog("uploadImage: %@", error?.localizedDescription ?? "ccccc")
                complete(false,error?.localizedDescription,nil)

                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            riversRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    NSLog("downloadURL: %@", error?.localizedDescription ?? "ccccc")

                    complete(false,error?.localizedDescription,nil)

                    return
                }
                
                complete(true,nil,downloadURL)
                
                
            }
            
            
        }
    }
    
    func parsePostData(_ snapshot: DataSnapshot) -> [PostDetail]{
        var posts:[PostDetail] = []
        for child in snapshot.children {
            if let dict = child as? DataSnapshot {
                if let postDict =  dict.value as? [String:Any]{
                    if let post = PostDetail(JSON: postDict){
                        post.key = dict.key
                        if let likes = postDict["likes"] as? [String:Any]{
                            for key in likes.keys{
                                if let value = likes[key] as? [String:Any] {
                                    if let userLike = UserLike(JSON: value){
                                        userLike.key = key
                                        post.likes.append(userLike)
                                    }
                                }
                            }
                            
                        }
                        if let comments = postDict["comments"] as? [String:Any]{
                            for key in comments.keys{
                                if let value = comments[key] as? [String:Any] {
                                    if let petComment = PetComment(JSON: value){
                                        petComment.key = key
                                        post.addComment(petComment)
                                    }
                                }
                            }
                        }
                        posts.append(post)
                    }
                }
            }
        }
        return posts
    }
}
