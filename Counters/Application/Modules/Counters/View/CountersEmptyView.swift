//
//  CountersEmptyView.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import UIKit

class CountersEmptyView: UIView {

    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.text = "COUNTERS_EMPTY_TITLE".localized
        view.font = UIFont.systemFont(ofSize: 22)
        view.textColor = .primaryText
        return view
    }()

    private let exampleLabel: UILabel = {
        let view = UILabel()
        view.text = "COUNTERS_EXAMPLE".localized
        view.font = UIFont.systemFont(ofSize: 17)
        view.textColor = .secondaryText
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var addButton: Button = {
        let view = Button(title: "Create a counter")
        view.addTarget(self, action: #selector(CountersEmptyView.addPressed), for: .touchUpInside)
        return view
    }()
    
    var addAction: (() -> ())?
    
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

private extension CountersEmptyView {
    func setupViews() {
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(exampleLabel)
        addSubview(addButton)
        setupConstraints()
    }
    
    func setupConstraints() {
        titleLabel.autoPinEdge(toSuperviewEdge: .top)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        
        exampleLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 20)
        exampleLabel.autoPinEdge(toSuperviewEdge: .leading)
        exampleLabel.autoPinEdge(toSuperviewEdge: .trailing)
        
        addButton.autoPinEdge(.top, to: .bottom, of: exampleLabel, withOffset: 20)
        addButton.autoAlignAxis(toSuperviewAxis: .vertical)
        addButton.autoPinEdge(toSuperviewEdge: .bottom)
    }
}

private extension CountersEmptyView {
    @objc private func addPressed() {
        addAction?()
    }
}
