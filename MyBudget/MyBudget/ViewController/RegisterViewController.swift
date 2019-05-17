//
//  RegisterViewController.swift
//  MyBudget
//
//  Created by Jenk on 2019/5/9.
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit
import RealmSwift
class RegisterViewController: UIViewController {

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var username: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func regist(_ sender: UIButton) {
        if password.text?.count == 0 {
            showAlertView(text: "Password")
        }else if username.text?.count == 0 {
            showAlertView(text: "Username")
        }else{
            //将账号密码插入数据库
            let realm = try! Realm()
            let user = User(value: ["username":username.text,"password":password.text])
            try! realm.write {
                //写入成功
                realm.add(user)
                showAlertView(text: "Done!")
                self.username.text = ""
                self.password.text = ""
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //显示警告框
    @objc func showAlertView( text:String) {
        let av = UIAlertController(title: "", message: text as String, preferredStyle: .alert)
        av.addAction(UIAlertAction.init(title: "OK", style: .default, handler: nil))
        self.present(av, animated: true, completion: nil)
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
