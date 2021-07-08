//
//  SignupVC.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 29/11/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit
import Alamofire

class SignupVC: BaseVC {
    
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtType: UITextField!
    @IBOutlet weak var txtGraduationDate: UITextField!
    @IBOutlet weak var txtInstagramAccount: UITextField!
    @IBOutlet weak var btnSelectType: UIButton!
    @IBOutlet weak var btnGraduationgDate: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var datePickerContainerView: UIView!
    
    var dropdownItems = ["Current Student", "Former Student", "Aggie Parent", "Aggie Friend"]
    var yearItemsArr = [String]()
    var isTypeSelected = true

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if let data = UserDefaults.standard.value(forKey:DefaultsKeys.USER_DETAILS) as? Data {
//            let userData = try? PropertyListDecoder().decode(UserModel.self, from: data)
//            guard let userObj = userData else { return }
//            AppDelegate.shared().showLandingPageNavigatonCntr()
//            return
//        
//        }
        
        for i in 1950...2020 {
            self.yearItemsArr.append(String(i))
        }
        self.yearItemsArr.append("Spring 2021")
        self.yearItemsArr.append("Fall 2021")
        self.yearItemsArr.append("Spring 2022")
        self.yearItemsArr.append("Summer 2022")
        self.yearItemsArr.append("Fall 2022")
        self.yearItemsArr.append("Spring 2023")
        self.yearItemsArr.append("Summer 2023")
        self.yearItemsArr.append("Fall 2023")
        self.yearItemsArr.append("Spring 2024")
        self.yearItemsArr.append("Summer 2024")
        self.yearItemsArr.append("Fall 2024")
        self.yearItemsArr.append("Spring 2025")
        self.yearItemsArr.append("Summer 2025")
        self.yearItemsArr.append("Fall 2025")
        self.yearItemsArr.append("Spring 2026")
        self.yearItemsArr.append("Summer 2026")
        self.yearItemsArr.append("Fall 2026")
        self.yearItemsArr.append("Spring 2027")
        self.yearItemsArr.append("Summer 2027")
        self.yearItemsArr.append("Fall 2027")
        self.yearItemsArr.append("Spring 2028")
        self.yearItemsArr.append("Summer 2028")
        self.yearItemsArr.append("Fall 2028")
        self.yearItemsArr.append("Spring 2029")
        self.yearItemsArr.append("Summer 2029")
        self.yearItemsArr.append("Fall 2029")
        
        self.datePickerContainerView.isHidden = true
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setupUI() {
        self.btnSelectType.layer.cornerRadius = 8.0
        self.btnSignup.layer.cornerRadius = 8.0
    }
    
    
    func setupDropdown() {
        DropdownView.shared.layer.cornerRadius = 8.0
        DropdownView.shared.delegate = self
        DropdownView.shared.items = dropdownItems
        DropdownView.shared.showFor(source: self.btnSelectType, onView: self.view, atPosition: .Bottom)
    }
    
    func setYearDrowdown() {
        DropdownView.shared.layer.cornerRadius = 8.0
        DropdownView.shared.delegate = self
        DropdownView.shared.items = yearItemsArr
        DropdownView.shared.showFor(source: self.btnGraduationgDate, onView: self.view, atPosition: .Bottom)
    }
    
    @IBAction func btnSelectDate(_ sender: UIButton) {
        isTypeSelected = false
        setYearDrowdown()
    }
    
    
    @IBAction func btnSelectType(_ sender: UIButton) {
            isTypeSelected = true
            setupDropdown()
       }
    
    @IBAction func btnBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
      
    @IBAction func btnHideDatePicker(_ sender: UIBarButtonItem) {
        self.datePickerContainerView.isHidden = true
    }
    
    @IBAction func dateSelectionSpinner(_ sender: UIDatePicker) {
        self.txtGraduationDate.text = sender.date.toString()
    }
    
    
    @IBAction func btnSignup(_ sender: UIButton) {
        
        let firstNameTxt = self.txtFirstName.text ?? ""
        let lastNameTxt = self.txtLastName.text ?? ""
        let emailTxt = self.txtEmail.text ?? ""
        let phoneTxt = self.txtPhone.text ?? ""
        let typeTxt = self.txtType.text ?? ""
        let graduationTxt = self.txtGraduationDate.text ?? ""
        let instaText = self.txtInstagramAccount.text ?? ""
        
        if firstNameTxt.count < 1 {
            self.showAlert(title: "", message: "First name can't be empty")
            return
        }
        
        if lastNameTxt.count < 1 {
            self.showAlert(title: "", message: "Last name can't be empty")
            return
        }
        
        if emailTxt.count < 1 {
            self.showAlert(title: "", message: "Email can't be empty")
            return
        }
        
        if phoneTxt.count < 1 {
            self.showAlert(title: "", message: "Phone number can't be empty")
            return
        }
        
        if typeTxt.count < 1 {
            self.showAlert(title: "", message: "Aggi Type can't be empty")
            return
        }
        
        if graduationTxt.count < 1 {
            self.showAlert(title: "", message: "Graduation year can't be empty")
            return
        }
        
        let params : [String:AnyObject] = ["first_name":firstNameTxt as AnyObject,
                                          "last_name":lastNameTxt as AnyObject,
                                          "email":emailTxt as AnyObject,
                                          "phone":phoneTxt as AnyObject,
                                          "student_type": typeTxt as AnyObject,
                                          "graduation_year": graduationTxt as AnyObject,
                                          "insta_account": instaText as AnyObject,
                                          "action": "create-user" as AnyObject]
       // self.API_LOGIN(params: parms as NSDictionary)
        
        let loginUrl = Constants.baseUrl + ApiEndPoints.registerUser
        
        Api.share().signup(url: loginUrl, params: params) { (isSuccess, message, userData) in
            if isSuccess {
                print(message)
                if let data = UserDefaults.standard.value(forKey:DefaultsKeys.USER_DETAILS) as? Data {
                    let userData = try? PropertyListDecoder().decode(UserModel.self, from: data)
                    guard let userObj = userData else { return }
                    self.navigationController?.popToRootViewController(animated: true)
                    //AppDelegate.shared().showLandingPageNavigatonCntr()
                }
            } else {
                self.showAlert(title: "", message: message ?? "")
            }
        }
        

    
        
        //let _ : HomeVC = self.open(storyBoardIdentifier: "Main", animate: true)
    }
    
    


}



extension SignupVC: DropdownViewDelegate {
    
    
    func dropDown(_ dropdown: DropdownView, didSelectItem item: String, atIndex index: Int) {
        if self.isTypeSelected {
            self.txtType.text = item
        } else {
            self.txtGraduationDate.text = item
        }
        
    }
    
    
    
}


