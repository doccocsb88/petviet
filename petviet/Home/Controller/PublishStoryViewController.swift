//
//  PublishStoryViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit
import Photos
class PublishStoryViewController: UIViewController {
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 2, left: 1, bottom: 2, right: 1)
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var placeHolderLabel: UILabel!
    @IBOutlet weak var inputStoryEdittext: UITextView!
    @IBOutlet weak var mediaContainerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var didPublishStory:() -> () = {}
    var allPhotos:PHFetchResult<PHAsset>?
    let imageManager = PHCachingImageManager()
    var currentImageIndex:Int = NSNotFound
    var imageUrl:URL?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
        fetchPhotoFromLibrary()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        collectionView.register(UINib(nibName: "StoryImageViewCell", bundle: nil), forCellWithReuseIdentifier: "imageCell")
        collectionView.register(UINib(nibName: "StoryCameraViewCell", bundle: nil), forCellWithReuseIdentifier: "cameraCell")

        //
        let tapped = UITapGestureRecognizer(target: self, action: #selector(tappedGesture(_:)))
        self.view.addGestureRecognizer(tapped)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func fetchPhotoFromLibrary(){
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                let fetchOptions = PHFetchOptions()
                self.allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                print("Found \(self.allPhotos?.count ?? 0) assets")
                
                self.collectionView.reloadData()
            case .denied, .restricted:
                print("Not allowed")
            case .notDetermined:
                // Should not see this when requesting
                print("Not determined yet")
            }
        }
    }
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            
            present(imagePicker, animated: true)
        }
    }
    @objc func tappedGesture(_ gesture:UIGestureRecognizer){
        self.view.endEditing(true)
    }
    @IBAction func tappedPublishButton(_ sender: Any) {
        guard let story = inputStoryEdittext.text, story.count > 0 else{return}
        guard let imageUrl = imageUrl else{return}

        let post = PostDetail(1, 1, "1234", "vuhai", story, "", "", created_date:Date().millisecondsSince1970)
        FirebaseServices.shared().uploadImage(imageUrl) { (success, message, url) in
            if success{
                post.imagePath = url?.absoluteString
                FirebaseServices.shared().publishPost(post) {[weak self] (success, message) in
                    guard let strongSelf = self else{return}
                    if success{
                        strongSelf.didPublishStory()
                        strongSelf.dismiss(animated: true, completion: nil)
                        
                    }
                }
            }
        }
        
    }
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
extension PublishStoryViewController:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true

    }
    func textViewDidEndEditing(_ textView: UITextView) {
   
         placeHolderLabel.isHidden = textView.text.count > 0
      
    }
}
extension PublishStoryViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allPhotos?.count ?? 0) + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cameraCell", for: indexPath) as! StoryCameraViewCell
            cell.didSelectCamera = {
                self.openCamera()
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! StoryImageViewCell
            let imageIndex = indexPath.row - 1
            if let asset = self.allPhotos?.object(at: imageIndex){
                let imageSize = CGSize(width: asset.pixelWidth,
                                       height: asset.pixelHeight)
                
                /* For faster performance, and maybe degraded image */
                let options = PHImageRequestOptions()
                options.deliveryMode = .fastFormat
                options.isSynchronous = true
                self.imageManager.requestImage(for: asset,
                                               targetSize: imageSize,
                                               contentMode: .aspectFill,
                                               options: options,
                                               resultHandler: {
                                                (image, info) -> Void in
                                                /* The image is now available to us */
                                                cell.updateContent(image,self.currentImageIndex == imageIndex)
                                                print("enum for image, This is number 2")
                                                
                })
                
            }
            cell.didSelectImage = { [unowned self ] in
                if let asset = self.allPhotos?.object(at: imageIndex){
                    asset.getURL(completionHandler: { (url) in
                        self.imageUrl = url
                    })
                }
                self.currentImageIndex = imageIndex
                self.collectionView.reloadData()
            }
            return cell

        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("didSelectItemAt %ld", indexPath.row)
    }
}
extension PublishStoryViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = UIScreen.main.bounds.width - paddingSpace - sectionInsets.left - sectionInsets.right
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.top
    }
}
extension PublishStoryViewController:UIImagePickerControllerDelegate,
UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
        }else{
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }

}
