//
//  Navigator.swift
//  BTG Global
//
//  Created by Dheeraj on 02/12/19.
//  Copyright © 2019 Dheeraj Chauhan. All rights reserved.
//

import Foundation
import UIKit

extension BaseVC {

    func changeRootViewController<T>(storyBoardIdentifier: String = "Main") -> T where T: UIViewController {

        return delegate.changeRootViewController(storyBoardIdentifier: storyBoardIdentifier)

    }

    func open<T>(storyBoardIdentifier: String = "Main",animate: Bool = true,_ attacher: (T) -> Void = {_ in } ) -> T where T: UIViewController{


        return navigationController!.open(storyBoardIdentifier: storyBoardIdentifier, animate: animate, attacher)

    }


    private func instantiateViewController<T>(storyBoardIdentifier: String) -> T{

        return delegate.instantiateViewController(storyBoardIdentifier: storyBoardIdentifier)

    }

}

extension UINavigationController {

    func transparentNavBar(){
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
        self.view.backgroundColor = .clear
    }

    func open<T>(storyBoardIdentifier: String = "Main",animate: Bool = true,_ attacher: (T) -> Void = {_ in } ) -> T where T: UIViewController{

        var destVc: T

        let controller =  viewControllers.first(where: ({$0 is T}))


        if(controller ==  nil) {
            destVc = instantiateViewController(storyBoardIdentifier: storyBoardIdentifier)

            attacher(destVc)
            pushViewController(destVc, animated: animate)
        } else {
            destVc = controller as! T
            attacher(destVc)
            popToViewController(controller!, animated: true)

        }

        return destVc

    }

    private func instantiateViewController<T>(storyBoardIdentifier: String) -> T{

        return AppDelegate.shared().instantiateViewController(storyBoardIdentifier: storyBoardIdentifier)

    }

}

extension AppDelegate {


    func changeRootViewController<T>(storyBoardIdentifier: String = "Main") -> T where T: UIViewController {

        let vc : T = instantiateViewController(storyBoardIdentifier: storyBoardIdentifier)

        let appDelegate = UIApplication.shared.delegate as! AppDelegate


        vc.view.layoutIfNeeded()

        UIView.transition(with: appDelegate.window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: vc)
        }, completion: { completed in
            // maybe do something here
        })
        return vc
    }

    fileprivate func instantiateViewController<T>(storyBoardIdentifier: String) -> T{

        let vcId = String(describing:  T.self)
        let board = storyBord(withIdentifier: storyBoardIdentifier)
        return board.instantiateViewController(withIdentifier: vcId) as! T

    }

    func storyBord(withIdentifier: String) -> UIStoryboard{
        return UIStoryboard(name: withIdentifier, bundle: nil)
    }

}

extension UINavigationController {
    func fadeInOutViewController(_ push:Bool,_ vc:UIViewController){
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        self.view.layer.add(transition, forKey: nil)
        if push{
            self.pushViewController(vc, animated: false)
        }
        else{
            self.popToViewController(vc, animated: false)
        }
    }


}
