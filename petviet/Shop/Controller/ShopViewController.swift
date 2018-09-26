//
//  ShopViewController.swift
//  petviet
//
//  Created by Macintosh HD on 9/22/18.
//  Copyright © 2018 csb. All rights reserved.
//

import UIKit

class ShopViewController: UIViewController {
    fileprivate let headerColors:[String] = ["#019EA6","#5F9CBC","#4B777E"]
    @IBOutlet weak var tableView: UITableView!
    var products:[ProductType]  = []
    var productTypes:[(Int,String)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupUI()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func initData(){
        let dog = Pet(type: 1, name: "Chó")
        let cat = Pet(type: 2, name: "Mèo")
        
        products.append(ProductType(1,1,cat.type,"Mèo","Thú cưng"))
        products.append(ProductType(2,1,dog.type,"Chó","Thú cưng"))
        //
        products.append(ProductType(3,2,dog.type,"Thức ăn cho chó","Thức ăn"))
        products.append(ProductType(4,2,cat.type,"Thức ăn cho mèo","Thức ăn"))
        //
        
        products.append(ProductType(5,3,cat.type,"Tắm spa chó mèo","Dịch vụ"))
        products.append(ProductType(6,3,cat.type,"Tỉa lông chó mèo","Dịch vụ"))
        products.append(ProductType(7,3,cat.type,"Trông giữ chó mèo","Dịch vụ"))
        //
        products.append(ProductType(8,4,dog.type,"Phụ kiện cho chó","Phụ kiện và đồ dùng"))
        products.append(ProductType(9,4,dog.type,"Đồ dùng cho chó","Phụ kiện và đồ dùng"))

        products.append(ProductType(9,5,cat.type,"Phụ kiện cho mèo","Phụ kiện và đồ dùng"))
        products.append(ProductType(9,5,cat.type,"Đồ dùng cho mèo","Phụ kiện và đồ dùng"))

        //
        products.append(ProductType(9,6,dog.type,"Thuốc thú y cho chó","Thuốc"))
        products.append(ProductType(9,6,cat.type,"Thuốc thú y cho mèo","Thuốc"))


        for product in products{
            var has = false
            for type in productTypes{
                if product.type == type.0{
                    has = true
                }
            }
            if has == false{
                productTypes.append((product.type, product.typeName))
            }
        }
        //
       
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
    func showPruductView(productType:ProductType){
        let vc = ListProductViewController(nibName: "ListProductViewController", bundle: nil)
        vc.productType = productType
        self.navigationController?.pushViewController(vc, animated: true)

        
    }
}

extension ShopViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return productTypes.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = productTypes[section]
        var count:Int = 0
        for product in products{
            if product.type == type.0{
                count += 1
            }
        }
        return count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        let titleLabel = UILabel(frame: CGRect(x: 20, y: 0, width: UIScreen.main.bounds.width - 20, height: 50))
        header.addSubview(titleLabel)
        let type = productTypes[section]
        titleLabel.text = type.1
        header.backgroundColor = UIColor(hexString: headerColors[section % headerColors.count])
        return header
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! ShopCategoryViewCell
        let type = productTypes[indexPath.section]
        let pros = getProduct(typeId: type.0)
        let product = pros[indexPath.row]
        cell.updateContent(product)
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = productTypes[indexPath.section]
        let pros = getProduct(typeId: type.0)
        let product = pros[indexPath.row]
        showPruductView(productType: product)
    }
    
    func getProduct(typeId:Int) -> [ProductType]{
        var pros:[ProductType] = []
        for product in products{
            if product.type == typeId{
                pros.append(product)
            }
        }
        return pros
    }
    
}
