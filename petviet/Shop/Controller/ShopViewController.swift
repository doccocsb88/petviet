//
//  ShopViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func setupUI(){
        self.title = BaseTabbarController.titles[2]
        self.tableView.register(UINib(nibName: "ShopCategoryViewCell", bundle: nil), forCellReuseIdentifier: "categoryCell")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func showShopView(){
        let vc = ListShopViewController(nibName: "ListShopViewController", bundle: nil)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func showPruductView(){
        let vc = ListProductViewController(nibName: "ListProductViewController", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
}

extension ShopViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ShopCategoryViewCell
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPruductView()
    }
}
