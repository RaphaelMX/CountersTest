//
//  CounterSkeletonView.swift
//  Counters
//
//  Created by Rafael Jimeno on 10/11/21.
//

import UIKit

class CounterSkeletonView: UIView {

    // MARK: - Properties
    
    private let holder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1)
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let countSkeleton = SkeletonView(frame: .zero)
    private let titleSkeleton = SkeletonView(frame: .zero)
    private let incrementorSkeleton = SkeletonView(frame: .zero)
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension CounterSkeletonView {
    func setupViews() {
        addSubview(holder)
        holder.addSubview(countSkeleton)
        holder.addSubview(titleSkeleton)
        holder.addSubview(incrementorSkeleton)
        setupConstraints()
    }
    
    func setupConstraints() {
        holder.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        holder.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        holder.autoPinEdge(toSuperviewEdge: .top, withInset: 4)
        holder.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        countSkeleton.autoPinEdge(toSuperviewEdge: .leading, withInset: 40)
        countSkeleton.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        countSkeleton.autoSetDimensions(to: CGSize(width: 26, height: 26))
        countSkeleton.layer.cornerRadius = 13
        
        titleSkeleton.autoPinEdge(.leading, to: .trailing, of: countSkeleton, withOffset: 20)
        titleSkeleton.autoPinEdge(.top, to: .top, of: countSkeleton)
        titleSkeleton.autoSetDimension(.height, toSize: 26)
        titleSkeleton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 14)
        
        incrementorSkeleton.autoPinEdge(.top, to: .bottom, of: titleSkeleton, withOffset: 17)
        incrementorSkeleton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 14)
        incrementorSkeleton.autoSetDimensions(to: CGSize(width: 100, height: 26))
        
    }
}
