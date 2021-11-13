//
//  UIColor+LookNFeel.swift
//  Counters
//
//  Created by Rafael Jimeno on 08/11/21.
//

import Foundation
import UIKit

extension UIColor {
    
    static var accentColor: UIColor {
        return UIColor(named: "AccentColor") ?? .black
    }
    
    static var backgroundColor: UIColor {
        return UIColor(named: "Background") ?? .black
    }
    
    static var buttonText: UIColor {
        return UIColor(named: "ButtonText") ?? .black
    }
    
    static var descriptionText: UIColor {
        return UIColor(named: "descriptionText") ?? .black
    }
    
    static var disableText: UIColor {
        return UIColor(named: "DisabledText") ?? .black
    }
    
    static var appGreen: UIColor {
        return UIColor(named: "Green") ?? .black
    }
    
    static var primaryText: UIColor {
        return UIColor(named: "PrimaryText") ?? .black
    }
    
    static var appRed: UIColor {
        return UIColor(named: "Red") ?? .black
    }
    
    static var secondaryText: UIColor {
        return UIColor(named: "SecondaryText") ?? .black
    }
    
    static var subtitleText: UIColor {
        return UIColor(named: "SubtitleText") ?? .black
    }
    
    static var yellow: UIColor {
        return UIColor(named: "Yellow") ?? .black
    }
}
