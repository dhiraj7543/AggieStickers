//
//  Loader.swift
//  Drovel
//
//  Created by Dheeraj Chauhan on 04/04/2020.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class Loader: NSObject {
    static let shared = Loader()
    var activityIndicatorView:NVActivityIndicatorView!
    var parentView:UIView!
    func show(){
        
        DispatchQueue.main.async{
            if self.activityIndicatorView == nil {
                self.parentView = UIView()
                self.parentView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
                self.parentView.frame = UIScreen.main.bounds
                var rect = CGRect.zero
                let height:CGFloat = 80
                let DEVICE_WIDTH = UIScreen.main.bounds.width
                let DEVICE_HEIGHT = UIScreen.main.bounds.height
                rect.origin.x =   (DEVICE_WIDTH - height)/2
                rect.origin.y = (DEVICE_HEIGHT - height)/2
                rect.size.width = height
                rect.size.height = height
                self.activityIndicatorView = NVActivityIndicatorView(frame: rect, type: .ballSpinFadeLoader, color: APP_BLUE_COLOR, padding: 5)
              }
            
            self.parentView.addSubview(self.activityIndicatorView)
            AppDelegate.shared().window?.addSubview(self.parentView)
            self.activityIndicatorView.startAnimating()
        }
    }
    
    func hide(){
        DispatchQueue.main.async {
            guard self.activityIndicatorView != nil else {return}
            self.activityIndicatorView.stopAnimating()
            self.activityIndicatorView.removeFromSuperview()
            self.parentView.removeFromSuperview()
        }
    }
}
