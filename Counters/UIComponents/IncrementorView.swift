//
//  IncrementorView.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import UIKit

class IncrementorView: UIView {
    
    // MARK: - Properties

    private let stackView: UIStackView = {
        let view = UIStackView()
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.layer.cornerRadius = 8
        view.backgroundColor = UIColor(red: 0.46, green: 0.46, blue: 0.46, alpha: 0.12)
        return view
    }()

    private lazy var incrementButton: UIButton = {
        let view = UIButton()
        view.setTitle("+", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        view.setTitleColor(.primaryText, for: .normal)
        view.addTarget(self, action: #selector(IncrementorView.incrementPressed), for: .touchUpInside)
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let view = UIButton()
        view.setTitle("-", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        view.setTitleColor(.primaryText, for: .normal)
        view.addTarget(self, action: #selector(IncrementorView.decrementPressed), for: .touchUpInside)
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        return view
    }()
    
    var incremented: (() -> ())?
    var decremented: (() -> ())?
    
    // MARK: - Initialization
    
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

private extension IncrementorView {
    func setupViews() {
        addSubview(stackView)
        addSubview(line)
        stackView.addArrangedSubview(decrementButton)
        stackView.addArrangedSubview(incrementButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        stackView.autoPinEdgesToSuperviewEdges()
        
        let size = CGSize(width: 50, height: 29)
        decrementButton.autoSetDimensions(to: size)
        incrementButton.autoSetDimensions(to: size)
        
        line.autoPinEdge(toSuperviewEdge: .top, withInset: 7)
        line.autoPinEdge(toSuperviewEdge: .bottom, withInset: 7)
        line.autoSetDimension(.width, toSize: 1)
        line.autoAlignAxis(toSuperviewAxis: .vertical)
    }
}

private extension IncrementorView {
    @objc func incrementPressed() {
        incremented?()
    }
    
    @objc func decrementPressed() {
        decremented?()
    }
}
