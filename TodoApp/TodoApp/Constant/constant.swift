//
//  Constant.swift
//  
//
//  Created by Adarsh Raj on 30/06/21.
//

import UIKit
import KRProgressHUD

//MARK:- For Indicator
class ProgressHud {
  
    static func show() {
        DispatchQueue.main.async {
            KRProgressHUD.show()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            KRProgressHUD.dismiss()
        }
    }
    
    
    
}
//Shadow
extension UIView
{
    func dropShadow() {

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 2, height: 3)
        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 3
        layer.rasterizationScale = UIScreen.main.scale
        layer.cornerRadius = 20
        layer.shouldRasterize = true
    }
}

