//
//  SkeletonView.swift
//  Counters
//
//  Created by Rafael Jimeno on 10/11/21.
//

import UIKit

class SkeletonView: UIView {
    
    private var gradLayer: CAGradientLayer!
    private var animationStarted = false
    private var animation: CABasicAnimation?
    
    //MARK: Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupSkeleton()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    //MARK: Private
    
    private func setup() {
        clipsToBounds = true
        layer.masksToBounds = true
        gradLayer = CAGradientLayer()
        gradLayer.colors = [UIColor(white: 0.95, alpha: 1).cgColor,
                            UIColor(white: 0.9, alpha: 1).cgColor,
                            UIColor(white: 0.9, alpha: 1).cgColor,
                            UIColor(white: 0.95, alpha: 1).cgColor]
        gradLayer.locations = [0, 0.45, 0.5, 1]
        gradLayer.startPoint = CGPoint(x: 0, y: 1)
        gradLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradLayer)
    }
    
    private func setupSkeleton() {
        animationStarted = true
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 6
        
        animation = CABasicAnimation(keyPath: "transform.translation.x")
        animation?.fromValue = -bounds.width
        animation?.toValue = bounds.width * 3
        animation?.duration = 2
        animation?.repeatCount = Float.infinity
        gradLayer.add(animation!, forKey: "slide")
    }
    
    deinit {
        animation = nil
    }
}
