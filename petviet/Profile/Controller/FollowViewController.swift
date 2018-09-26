//
//  FollowViewController.swift
//  petviet
//
//  Created by Hai Vu on 9/26/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class FollowViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var follows:[PetFollow] = []
    var following:Bool = false
    var didUploadFollow:()->() = {}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.title = "Following"
        addDefaultLeft()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI(){
        tableView.register(UINib(nibName: "FollowViewCell", bundle: nil), forCellReuseIdentifier: "followCell")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func tappedLeftButton(_ button: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension FollowViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return follows.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followCell", for: indexPath) as! FollowViewCell
        
        let follow = follows[indexPath.row]
        cell.updateContent(follow, following)
        
        cell.didTappedUnFollow = {
            FirebaseServices.shared().unfollow(follow, complete: {[weak self] (success, message) in
                guard let strongSelf = self else {return}
                DataServices.shared().unFollow(follow)
                if strongSelf.following{
                    strongSelf.follows = DataServices.shared().profile.following()
                }else{
                    strongSelf.follows = DataServices.shared().profile.followers()
                }
                strongSelf.tableView.reloadData()
                strongSelf.didUploadFollow()
            })
        }
        
        return cell
    }
}
