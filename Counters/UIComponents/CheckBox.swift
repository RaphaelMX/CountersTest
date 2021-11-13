//
//  CheckBox.swift
//  Counters
//
//  Created by Rafael Jimeno on 10/11/21.
//

import UIKit

class CheckBox: UIView {
    
    // MARK: - Properties

    private lazy var button: UIButton = {
        let view = UIButton()
        view.setTitleColor(.backgroundColor, for: .normal)
        view.backgroundColor = .clear
        view.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        view.addTarget(self, action: #selector(pressed), for: .touchUpInside)
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    var valueChanged: ((_ isSelected: Bool) -> ())?
    
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

private extension CheckBox {
    @objc func pressed() {
        updateSelection()
    }
}

private extension CheckBox {
    func setupViews() {
        backgroundColor = .clear
        addSubview(button)
        setupConstraints()
    }
    
    func setupConstraints() {
        button.autoSetDimensions(to: CGSize(width: 26, height: 26))
        button.autoPinEdgesToSuperviewEdges()
    }
    
    func updateSelection() {
        button.isSelected = !button.isSelected
        updateStyle()
        valueChanged?(button.isSelected)
    }
    
    func updateStyle() {
        if button.isSelected {
            button.backgroundColor = .accentColor
            button.setTitle("✓", for: .normal)
            button.layer.borderWidth = 0
        } else {
            button.backgroundColor = .clear
            button.setTitle("", for: .normal)
            button.layer.borderWidth = 1
        }
    }
}

// MARK: Public

extension CheckBox {
    func uncheck() {
        button.isSelected = false
        updateStyle()
    }
    
    func check() {
        button.isSelected = true
        updateStyle()
    }
}
