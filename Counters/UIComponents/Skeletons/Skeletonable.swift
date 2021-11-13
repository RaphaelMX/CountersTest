//
//  Skeletonable.swift
//  Counters
//
//  Created by Rafael Jimeno on 10/11/21.
//

import Foundation
import UIKit

enum SkeletonViewType {
    case counter
}

protocol Skeletonable where Self: UIView {
    func addSkeletonView(with type: SkeletonViewType)
    func removeSkeletonView()
}

extension Skeletonable {
    func addSkeletonView(with type: SkeletonViewType) {
        removeSkeletonView()
        
        switch type {
        case .counter:
            let skeletonView = CounterSkeletonView()
            addSubview(skeletonView)
            skeletonView.tag = 919
            skeletonView.autoPinEdgesToSuperviewEdges()
        }
    }
    
    func removeSkeletonView() {
        var prevSkeletonView = viewWithTag(919)
        prevSkeletonView?.removeFromSuperview()
        prevSkeletonView = nil
    }
}
