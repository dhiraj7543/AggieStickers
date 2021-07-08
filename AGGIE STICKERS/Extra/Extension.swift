//
//  Extension.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 29/11/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit


// Mark: - Date Extensions

extension Date {
    
    func toString(format: String = "dd-MM-yyyy") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func dateAndTimetoString(format: String = "yyyy-MM-dd HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    func timeIn24HourFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func timeIn12HourFormat() -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .none
           formatter.dateFormat = "hh:mm a"
           return formatter.string(from: self)
       }
    
     // Convert local time to UTC (or GMT)
       func toGlobalTime() -> Date {
           let timezone = TimeZone.current
           let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
           return Date(timeInterval: seconds, since: self)
       }

       // Convert UTC (or GMT) to local time
       func toLocalTime() -> Date {
           let timezone = TimeZone.current
           let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
           return Date(timeInterval: seconds, since: self)
       }

}


public extension UIAlertController {
    func show() {
        let win = UIWindow(frame: UIScreen.main.bounds)
        let vc = UIViewController()
        vc.view.backgroundColor = .clear
        win.rootViewController = vc
        win.windowLevel = UIWindow.Level.alert + 1
        win.makeKeyAndVisible()
        vc.present(self, animated: true, completion: nil)
    }
}

extension UIViewController {
  public func addActionSheetForiPad(actionSheet: UIAlertController) {
    if let popoverPresentationController = actionSheet.popoverPresentationController {
      popoverPresentationController.sourceView = self.view
      popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
      popoverPresentationController.permittedArrowDirections = []
    }
  }
}



extension UIViewController {
    
    /// An alert view
    func showAlert(title: String?, message: String?) {
        showAlert(title: title, message: message) { () in
            
        }
    }
    
    func showAlert(title: String?, message: String?, completionAction:@escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
//            let titleFont = [NSAttributedString.Key.font: UIFont(name: "Fineness-Regular", size: 16.0)!]
//            let titleAttrString = NSMutableAttributedString(string: message ?? "", attributes: titleFont)
//            alert.setValue(titleAttrString, forKey: "attributedMessage")
//
//
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                completionAction()
            }))
         
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func showAlertOnWindow(title: String?, message: String?) {
        showAlertOnWindow(title: title, message: message) { () in
        }
    }
    
    func showAlertOnWindow(title: String?, message: String?, completionAction:@escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
                completionAction()
            }))
            
            alert.show()
        }
    }
    func showAlert(title: String?, message: String?, okTitle: String?, cancelTitle: String?, completionAction:@escaping (_ isOk: Bool) -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        
            alert.addAction(UIAlertAction(title: okTitle, style: .default, handler: { (action) in
                completionAction(true)
            }))
            
            alert.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (action) in
                completionAction(false)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func push(_ controller: UIViewController, animated: Bool) {
        self.navigationController?.pushViewController(controller, animated: animated)
    }
    
    func pop(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
}


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
