//
//  StickerDataModel.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 07/12/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import Foundation


struct StickerDataModel: Codable {
    
    var id: Int?
    var sticker: String?
    var status: Int?
   
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case sticker
        case status
        
    }
 
    
    
}
