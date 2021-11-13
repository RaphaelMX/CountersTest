//
//  ActionBottomView.swift
//  Counters
//
//  Created by Rafael Jimeno on 08/11/21.
//

import UIKit
import PureLayout

protocol ActionBottomViewDelegate: AnyObject {
    func addPressed()
    func deletePressed()
}

class ActionBottomView: UIView {
    
    // MARK: - View model
    
    struct ViewModel {
        var title: String
    }
    
    // MARK: - Properties
    
    private var editEnabled = false
    
    private lazy var actionButton: UIButton = {
        let view = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 22)
        view.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        view.tintColor = .accentColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(ActionBottomView.actionPressed), for: .touchUpInside)
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.textColor = .descriptionText
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    weak var delegate: ActionBottomViewDelegate?
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    // MARK: - Initialization
    
    init(withDelegate delegate: ActionBottomViewDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Implementation

private extension ActionBottomView {
    func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .backgroundColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: -3)
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.08
        
        addSubview(actionButton)
        addSubview(titleLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        actionButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        actionButton.autoPinEdge(toSuperviewEdge: .top, withInset: 7)
        actionButton.autoSetDimensions(to: CGSize(width: 30, height: 30))
        
        titleLabel.autoAlignAxis(.horizontal, toSameAxisOf: actionButton)
        titleLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        titleLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 14 + UIScreen.bottomMargin)
    }
}

private extension ActionBottomView {
    @objc private func actionPressed() {
        if editEnabled {
            delegate?.deletePressed()
        } else {
            delegate?.addPressed()
        }
    }
}

// MARK: - Public

extension ActionBottomView {
    func update(editEnabled: Bool) {
        self.editEnabled = editEnabled
        
        let config = UIImage.SymbolConfiguration(pointSize: 22)
        if editEnabled {
            actionButton.setImage(UIImage(systemName: "trash", withConfiguration: config), for: .normal)
        } else {
            actionButton.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        }
     }
}
