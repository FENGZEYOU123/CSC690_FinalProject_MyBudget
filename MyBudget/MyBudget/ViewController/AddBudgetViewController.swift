//
//  AddBudgetViewController.swift
//  MyBudget
//
//  Created by Zeyuan Cai on 2019/04/12.
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit
import RealmSwift
class AddBudgetViewController: UIViewController,MapDelegate,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var type: UISegmentedControl!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var typeStr: UILabel!
    @IBOutlet weak var remakTF: UITextField!
    var date = String()
    var address = String()
    var isShow = false //用来判断当前是否显示了选择类型
    var type2 = 0
    var tableView = UITableView()
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.locale = Locale(identifier: "en_US")
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    //点击类型
    @IBAction func touchType(_ sender: UIButton) {
        //如果当前已经显示了,隐藏选择栏
        if isShow == true {
            self.tableView.removeFromSuperview()
            isShow = false
        }else{
            //如果没有 显示tableview
            self.tableView = UITableView()
            self.tableView.frame = CGRect.init(x: 8, y: 286+60, width: self.view.frame.width-16, height: 0)
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
//            self.tableView.layer.masksToBounds = true;
//            self.tableView.layer.borderWidth = 1;
            self.view .addSubview(self.tableView)
            UIView.animate(withDuration: 0.3) {
                self.tableView.frame = CGRect.init(x: 8, y: 286+60, width: self.view.frame.width-16, height: 44*5)
            }
            isShow = true
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5;
    }
    //选择栏显示
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "Cell"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        if indexPath.row == 0 {
            cell?.textLabel?.text = "Food"
            cell?.imageView?.image = UIImage(imageLiteralResourceName: "type1")
        }else if indexPath.row == 1 {
            cell?.textLabel?.text = "Travel"
            cell?.imageView?.image = UIImage(imageLiteralResourceName: "type2")
        }else if indexPath.row == 2 {
            cell?.textLabel?.text = "Shopping"
            cell?.imageView?.image = UIImage(imageLiteralResourceName: "type3")
        }else if indexPath.row == 3 {
            cell?.textLabel?.text = "Transportation"
            cell?.imageView?.image = UIImage(imageLiteralResourceName: "type4")
        }else{
            cell?.textLabel?.text = "Other"
            cell?.imageView?.image = UIImage(imageLiteralResourceName: "type5")
        }
        return cell!
    }
    //点击
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        type2 = indexPath.row
        if indexPath.row == 0 {
            self.typeStr.text = "Food"
        }else if indexPath.row == 1 {
            self.typeStr.text = "Travel"
        }else if indexPath.row == 2 {
            self.typeStr.text = "Shopping"
        }else if indexPath.row == 3 {
            self.typeStr.text = "Transportation"
        }else{
            self.typeStr.text = "Other"
        }
        self.tableView .removeFromSuperview()
    }
    
    //s点击完成
    @IBAction func touchDone(_ sender: Any) {
        print("touchDone")
        if(price.text?.count == 0){
            showAlertView(text: "Amount")
        }else if(remakTF.text?.count == 0){
            showAlertView(text: "Add Record")
        }else if(address.count == 0){
            showAlertView(text: "Add Location")
        }else if(date.count == 0){
            showAlertView(text: "Date")
        }else{
            let realm = try! Realm()
            let priceText = price.text
            let remakText = remakTF.text
            var expenseText = ""
            if type2 == 0 {
                expenseText = "Food"
            }else if type2 == 1 {
                expenseText = "Travel"
            }else if type2 == 2 {
                expenseText = "Shopping"
            }else if type2 == 3 {
                expenseText = "Transportation"
            }else{
                expenseText = "Other"
            }
            let budget = Budget(value: ["priceStr":priceText,"typeInt":"\(type.selectedSegmentIndex)","remakStr":remakText,"expenseStr":expenseText,"dateStr":date,"addressStr":address,"username":UserDefaults.standard.object(forKey: "username")])
            try! realm.write {
                realm.add(budget)
                showAlertView(text: "Done")
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    //选择位置
    @IBAction func touchAddress(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didDelegateText(text: String) {
        self.address = text
        addressLabel.text = text
    }
    
    //显示警告框
    @objc func showAlertView( text:String) {
        let av = UIAlertController(title: "", message: text as String, preferredStyle: .alert)
        av.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(av, animated: true, completion: nil)
    }

    //日期选择器响应方法
    @objc func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        date = formatter.string(from: datePicker.date)
        self.dateLabel.text = date
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
