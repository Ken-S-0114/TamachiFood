//
//  SelectFoodViewController.swift
//  TamachiFood
//
//  Created by sato.ken on 2019/06/13.
//  Copyright © 2019 佐藤賢. All rights reserved.
//

import Firebase
import UIKit

class SelectFoodViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    // インスタンス変数
    var DBRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // インスタンスを作成
        DBRef = Database.database().reference()
    }
    
    @IBAction func add(_ sender: UIButton) {
        let age: Int = Int(textField.text!)!
        let data = ["age": age]
        DBRef.child("user/01").setValue(data)
        
        let defaultPlace = DBRef.child("user/01/age")
        defaultPlace.observe(.value) { (snap: DataSnapshot) in
            self.label.text = (snap.value! as AnyObject).description
        }
    }
}
