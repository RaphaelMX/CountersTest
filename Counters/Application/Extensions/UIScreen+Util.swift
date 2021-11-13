//
//  UIScreen+Util.swift
//  Counters
//
//  Created by Rafael Jimeno on 08/11/21.
//

import Foundation
import UIKit

extension UIScreen {
    static var bottomMargin: CGFloat {
        return (UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0)
    }
    
    static var topottomMargin: CGFloat {
        return (UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0)
    }
}
