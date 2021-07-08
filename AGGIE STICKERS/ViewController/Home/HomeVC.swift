//
//  HomeVC.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 03/12/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit

class HomeVC: BaseVC {
    
    
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var nodata_found_view: UIView!
    
    
    var arrSticker = [StickerDataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStickers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.nodata_found_view.isHidden = true
    }
    

    func fetchStickers() {
        let stickerUrl = Constants.baseUrl + ApiEndPoints.registerUser
        
        let params : [String:AnyObject] = ["action": "fetch-stickers" as AnyObject]
        
        
        Api.share().fetchStickers(url: stickerUrl, params: params) { (success, message, sticker_data) in
            
            if success {
                self.arrSticker = sticker_data ?? []
                self.stickerCollectionView.reloadData()
                if self.arrSticker.count < 1 {
                    self.nodata_found_view.isHidden = false
                } else {
                    self.nodata_found_view.isHidden = true
                }
                
            } else {
                self.showAlert(title: "", message: message ?? "")
            }
        }
    }
   

}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrSticker.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeStickersCVC", for: indexPath) as! HomeStickersCVC
        cell.setStickerData(model: arrSticker[indexPath.row])
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let cellWidth = collectionView.frame.size.width
        return CGSize(width: (cellWidth / 3) - 16 , height: (cellWidth / 3) - 16 )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
        
        if self.arrSticker.count > 1 {
            if indexPath.row > 1 {
                if let _ = UserDefaults.standard.value(forKey:DefaultsKeys.USER_DETAILS) as? Data {
                    let _: Share_VC = self.open(storyBoardIdentifier: kMainStoryboardIdentifier, animate: true) { (vc) in
                        vc.imageUrl = arrSticker[indexPath.row].sticker ?? ""
                    }
                   // let userData = try? PropertyListDecoder().decode(UserModel.self, from: data)
                 //   guard let userObj = userData else { return }
                //    AppDelegate.shared().showLandingPageNavigatonCntr()
                //    return
                
                } else {
                    
                    self.showAlert(title: "", message: "Only first two stickers are availabe, please signup for all stickers", okTitle: "Ok", cancelTitle: "Cancel") { (success) in
                        if success {
                            let _: SignupVC = self.open(storyBoardIdentifier: kMainStoryboardIdentifier, animate: true)
                        } else {
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            } else {
                let _: Share_VC = self.open(storyBoardIdentifier: kMainStoryboardIdentifier, animate: true) { (vc) in
                    vc.imageUrl = arrSticker[indexPath.row].sticker ?? ""
                }
            }
        }
        
        
       
        
        
        
       
    }
}
