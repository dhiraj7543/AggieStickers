//
//  Share_VC.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 29/11/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//


import UIKit
import SDWebImage
import Photos

class Share_VC: UIViewController  {

    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var shareImgView: UIImageView!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnWhatsapp: UIButton!
    @IBOutlet weak var btnInstaShare: UIButton!
    
    var selectedImg:UIImage!
    var imageUrl: String?
 
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
       // self.topView.backgroundColor = themeColor
        
        shareBtn.layer.cornerRadius = 12
        shareBtn.layer.borderWidth = 2.5
        let newString = (imageUrl ?? "").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
        if newString.contains(".gif") {
            self.btnInstaShare.isHidden = false
        } else {
            self.btnInstaShare.isHidden = true
        }
        guard let imgUrl = URL(string: newString) else{return}
        shareImgView.sd_setImage(with: imgUrl, completed: nil)
        
        btnWhatsapp.layer.cornerRadius = 12
        btnFacebook.layer.cornerRadius = 12
        
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    
    
    
    @IBAction func onclickshareBtn(_ sender: Any){
        
    //    guard let sharedImg = shareImgView.image else {return}
        
        
        do {
            guard let imgUrl = URL(string: imageUrl ?? "") else {return}
            let shareData = try Data(contentsOf: imgUrl)
            let shareItems:Array = [shareData]
            let activityViewController:UIActivityViewController = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
          //  activityViewController.excludedActivityTypes = [UIActivity.ActivityType.post]
            self.present(activityViewController, animated: true, completion: nil)
        } catch {
            
        }
        
     
    }
    
    @IBAction func btnWhatsapp(_ sender: UIButton) {
        let originalString = ""
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url  = URL(string: "whatsapp://send?text=\(escapedString!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func btnInstaShare(_ sender : UIButton) {
      //  let data = try! Data(contentsOf: Bundle.main.url(forResource: "gif", withExtension: "gif")!)
        let newString = (imageUrl ?? "").addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
      //  let gifURL : String = "http://www.gifbin.com/bin/4802swswsw04.gif"
     //   let imageURL = UIImage.gifImageWithURL(gifURL)
        let tempUrl = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent("temp.mp4")
        guard let gifUrl = URL(string: newString) else {return}
        guard let gifData = try? Data(contentsOf: gifUrl) else {return}
        let mp4Media = GIF2MP4(data: gifData)?.convertAndExport(to: tempUrl, completion: {
            PHPhotoLibrary.shared().performChanges({
                 PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: tempUrl)}) {
                 saved, error in
                 if saved {
                      print("Save status SUCCESS")
//                    if UIApplication.shared.canOpenURL("instagram://app") { // has Instagram
//                        let url = URL(string: "instagram://library?LocalIdentifier=" + videoLocalIdentifier)
//
//                        if UIApplication.shared.canOpenURL(url) {
//                            UIApplication.shared.open(url, options: [:], completionHandler:nil)
//                        }
//                    }
                    DispatchQueue.main.async {
                        
                    if let urlFromStr = URL(string: "instagram://app") {
                            
                            if UIApplication.shared.canOpenURL(urlFromStr) { // has Instagram
                                guard let url = URL(string: "instagram://library?LocalIdentifier=" + tempUrl.description) else {return}

                                if UIApplication.shared.canOpenURL(url) {
                                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                                }
                            }
                    }
                        
                    }
                   
                 }
            }
        })
        print(mp4Media)
        
        
    }
    
    @IBAction func btnFacebook(_ sender: UIButton) {
        guard let url = URL(string: "") else{ return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
  
    
    @IBAction func onclickBackBtn(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
       
    }
    
   

}
