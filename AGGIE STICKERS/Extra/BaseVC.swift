//
//  BaseVC.swift
//  AJT
//
//  Created by Charanjit Singh on 10/10/19.
//  Copyright © 2019 enAct eServices. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    func showLogoutAlert(message:String, completion: @escaping(Bool) -> Void) {
           
           let refreshAlert = UIAlertController(title: "", message: message, preferredStyle: .alert)

           refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                 print("Handle Ok logic here")
               completion(true)
           }))

           refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                 print("Handle Cancel Logic here")
               completion(false)
           }))
           addActionSheetForiPad(actionSheet: refreshAlert)
           present(refreshAlert, animated: true, completion: nil)
       }
    
    


}
