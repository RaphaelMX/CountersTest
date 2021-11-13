//
//  String+Localizable.swift
//  Counters
//
//  Created by Rafael Jimeno on 08/11/21.
//

import Foundation

extension String {
    
    var localized: String {
        NSLocalizedString("\(self)", comment: "")
    }
}
