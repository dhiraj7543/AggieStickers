//
//  Constants.swift
//  Aradous
//
//  Created by Dheeraj Chauhan on 24/04/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit


let kMainStoryboardIdentifier = "Main"
let kAuthStoryboardIdentifier = "Auth"
let kHomeStoryboardIdentifier = "Home"
let kAdminStoryboardIdentifier = "Admin"


//Color Const

let APP_BLUE_COLOR =  UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
let LIGHT_GRAY_COLOR =  UIColor(red: 170.0/255, green: 170.0/255, blue: 170.0/255, alpha: 0.5)



let kNoInternetTitle = "Internet Error!"
let kNoInternetMessage = "You are not connected to the network. Please check your connection and try again."

let kEmailNotVerifiedMessage = "Your account is not verified yet. \n\nPlease verify the account by clicking the confirmation link sent to your registered email address"


func isInternetRequired() -> Bool {
//    let status = AppDelegate.shared().reachability.connectionStatus()
//    switch status {
//    case .Online(let networkType):
//        return false
//    default:
//        return true
//    }
    return false
}



struct Constants {
    
    //The API's base URL    
    // Stage Url
    static let baseUrl = "https://www.aggiestickers.com/api/"
   static let  access_token = "access_token"
  
    // MARK:- Methods
    

    //The header fields
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
    }
    
    //The content type (JSON)
    enum ContentType: String {
        case json = "application/x-www-form-urlencoded"
    }
    
}

enum STATUS_CODE: Int {
    
    case success = 200
    case already_registered = 400
}



struct DefaultsKeys {
    static let USER_DETAILS = "USER_DETAILS"
  }



// Login
struct ApiEndPoints {
    static let registerUser = "?action=create-user"
    static let uploadSticker = "?action=upload-stickers"
    static let fetch_stickers = "?action=fetch-stickers"
    
    
}

  


struct AlertMessage {
    static var SET_DEFAULT_ADDRESS = "Are you sure you want to set this address as default?"
    static var DELETE_ADDRESS = "Are you sure you want to delete this address?"
    static var ADDRESS_CREATED = "Address created."
}

