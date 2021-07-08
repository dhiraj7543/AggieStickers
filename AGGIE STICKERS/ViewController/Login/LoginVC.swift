//
//  LoginVC.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 29/11/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var lblUserName: UITextField!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnLogin.layer.cornerRadius = 6.0
        self.lblUserName.layer.cornerRadius = 6.0
        self.lblPassword.layer.cornerRadius = 6.0
    }
      
    
  
    @IBAction func btnLogin (_ sender: UIButton) {
        
    }
    
    
    @IBAction func btnSignup (_ sender: UIButton) {
           
       }
    

    

}


