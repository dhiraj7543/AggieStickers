//
//  UserModel.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 05/12/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import Foundation


struct UserModel: Codable {
    
    var first_name: String?
    var last_name: String?
    var email: String?
    var phone: String?
    var student_type: String?
    var graduation_year: String?
    var insta_account: String?
    var action: String?
    var id: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case first_name
        case last_name
        case email
        case phone
        case student_type
        case graduation_year
        case insta_account
        case action
        case id
        
    }
 
    
    
}
