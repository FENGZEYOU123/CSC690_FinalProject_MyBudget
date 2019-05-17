//
//  ViewController.swift
//  MyBudget
//
//  Created by Zeyuan Cai on 2019/04/12.
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit
import RealmSwift
class Budget: Object {
    @objc dynamic var username : String?//用户id
    @objc dynamic var priceStr : String?//金额
    @objc dynamic var typeInt : String?//类型 支出收入
    @objc dynamic var remakStr : String?//备注
    @objc dynamic var expenseStr : String?//分类
    @objc dynamic var dateStr : String?//日期
    @objc dynamic var addressStr : String?//地址
}
class User: Object {
    @objc dynamic var username : String?//用户名
    @objc dynamic var password : String?//密码
}
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    @IBOutlet weak var segmented: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalIncome: UILabel!
    @IBOutlet weak var totalExpenditure: UILabel!
    @IBOutlet weak var totalMoney: UILabel!
    var datas = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "BudgetTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
    }

    //更新数据
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }

    @IBAction func change(_ sender: Any) {
        update()
    }
    @objc func update() {
        if(segmented.selectedSegmentIndex == 0){
            let realm = try! Realm()
            let budgets = realm.objects(Budget.self).sorted(byKeyPath: "dateStr", ascending: false)
            datas = NSMutableArray()
            for data in budgets {
                //筛选当前用户的数据
                if data.username == UserDefaults.standard.object(forKey: "username") as! String {
                    datas.add(data)
                }
            }
            var Expenditure:Int! = 0
            var Income:Int! = 0
            for i in datas {
                let data = i as! Budget
                    if data.typeInt == "0" {
                        let price = data.priceStr
                        Expenditure = Expenditure + Int(price!)!
                        self.totalExpenditure.text = "Expense: \(Expenditure ?? 0)"
                    }else{
                        let price = data.priceStr
                        Income = Income + Int(price!)!
                        self.totalIncome.text = "Income: \(Income ?? 0)"
                    }
                }
            if (Income <= Expenditure) {
                totalMoney.text = "Balance: -\(Expenditure - Income)"
            }else{
                totalMoney.text = "Balance: +\(Income - Expenditure)"
            }
            
            tableView.reloadData()
        }else{
            let realm = try! Realm()
            let budgets = realm.objects(Budget.self).sorted(byKeyPath: "dateStr", ascending: true)
            datas = NSMutableArray()
            for data in budgets {
                //筛选当前用户的数据
                if data.username == UserDefaults.standard.object(forKey: "username") as! String {
                    datas.add(data)
                }
            }
            
            var Income:Int! = 0
            var Expenditure:Int! = 0
            for i in datas {
                let data = i as! Budget
                    if data.typeInt == "1" {
                        let price = data.priceStr
                        Income = Income + Int(price!)!
                        self.totalIncome.text = "Income: \(Income ?? 0)"
                    }else{
                        let price = data.priceStr
                        Expenditure = Expenditure + Int(price!)!
                        self.totalExpenditure.text = "Expense: \(Expenditure ?? 0)"
                    }
            }
            if (Income <= Expenditure) {
                totalMoney.text = "Balance: -\(Expenditure - Income)"
            }else{
                totalMoney.text = "Balance: +\(Income - Expenditure)"
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BudgetTableViewCell
        let budget = datas[indexPath.row] as! Budget
        cell.dateLabel.text = budget.dateStr
        cell.expenseLaebl.text = budget.expenseStr
        cell.addressLabel.text = budget.addressStr
        cell.remakLabel.text = budget.remakStr
        if budget.typeInt == "0" {
            cell.priceLabel.text = "-\(budget.priceStr ?? "")"
            cell.priceLabel.textColor = UIColor.red
        }else{
            cell.priceLabel.text = "+\(budget.priceStr ?? "")"
            cell.priceLabel.textColor = UIColor.green
        }
        
        if budget.expenseStr == "Food" {
            cell.typeIMG.image = UIImage.init(imageLiteralResourceName: "type1")
        }else if budget.expenseStr == "Travel" {
            cell.typeIMG.image = UIImage.init(imageLiteralResourceName: "type2")
        }else if budget.expenseStr == "Shopping" {
            cell.typeIMG.image = UIImage.init(imageLiteralResourceName: "type3")
        }else if budget.expenseStr == "Transportation" {
            cell.typeIMG.image = UIImage.init(imageLiteralResourceName: "type4")
        }else{
            cell.typeIMG.image = UIImage.init(imageLiteralResourceName: "type5")
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
    }
    
    //cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128.0
    }
    //删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let realm = try! Realm()
        let budget = datas[indexPath.row] as! Budget
        try! realm.write {
            realm.delete(budget)
        }
        update()
    }
}

