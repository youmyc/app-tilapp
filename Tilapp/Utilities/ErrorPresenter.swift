//
//  ErrorPresenter.swift
//  Tilapp
//
//  Created by mac on 2019/2/21.
//  Copyright © 2019 youmy. All rights reserved.
//

import Foundation
import UIKit

final class ErrorPresenter {
    class func showError(message:String, on: AnyObject?) {
        
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.last!
            
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.backgroundColor = .darkGray
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.sizeToFit()
            label.frame.size.width = label.frame.width + 20
            label.frame.size.height = label.frame.height + 20
            label.center = window.center
            
            window.addSubview(label)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                label.removeFromSuperview()
            })
        }
    }
    
    class func showError(message:String, on: AnyObject?, _ completion:@escaping ()->()) {
        
        DispatchQueue.main.async {
            let window = UIApplication.shared.windows.last!
            
            let label = UILabel()
            label.text = message
            label.textColor = .white
            label.backgroundColor = .darkGray
            label.textAlignment = .center
            label.layer.cornerRadius = 5
            label.layer.masksToBounds = true
            label.sizeToFit()
            label.frame.size.width = label.frame.width + 20
            label.frame.size.height = label.frame.height + 20
            label.center = window.center
            
            window.addSubview(label)
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                label.removeFromSuperview()
            })
            completion()
        }
    }
}
