//
//  UIDevice+Util.swift
//  Counters
//
//  Created by Rafael Jimeno on 12/11/21.
//

import Foundation

extension UIDevice {
    static var isIPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
