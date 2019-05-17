//
//  LoginViewController.swift
//  MyBudget
//
//  Created by Zeyuan Cai on 2019/04/12.
//  Copyright © 2019 Zeyuan Cai. All rights reserved.
//

import UIKit
import RealmSwift
class LoginViewController: UIViewController {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func touchLogin(_ sender: Any) {
        
     /*   if username.text != "admin" {
            showAlertView(text: "username is error")
        }else if password.text != "123456" {
            showAlertView(text: "password is error")
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    } */

        if username.text?.count == 0 {
            showAlertView(text: "Username")
        }else if password.text?.count == 0 {
            showAlertView(text: "Password")
        }else{
            //获取数据库所有user
            var datas = Array<Any>()
            let realm = try! Realm()
            let users = realm.objects(User.self)
            datas = Array(users)
            for i in datas {
                let data = i as! User
                //先判断是否有输入的用户名
                if username.text == data.username {
                    //再判断密码是否一样.
                    if password.text == data.password {
                        //保存当前用户名 后面筛选数据需要用到
                        UserDefaults.standard.set(username.text, forKey: "username")
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(vc, animated: true)
                    }else{
                        showAlertView(text: "Password is Wrong")
                    }
                }
            }
        }
    }
        
    
    @objc func showAlertView( text:String) {
        let av = UIAlertController(title: text, message: "", preferredStyle: .alert)
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
