//
//  HomeStickersCVC.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 03/12/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit
import SDWebImage

class HomeStickersCVC: UICollectionViewCell {
    
    @IBOutlet weak var imgSticker: UIImageView!
    @IBOutlet weak var imgContainerView: UIView!
    
    func setStickerData(model: StickerDataModel){
        guard let stickerUrl = URL(string: model.sticker ?? "") else {return}
        self.imgSticker.sd_setImage(with: stickerUrl, placeholderImage: UIImage(named: "placeholder-image"), options: .refreshCached, context: nil)
    }
    
}
