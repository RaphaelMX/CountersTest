//
//  CounterCell.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import UIKit

class CounterCell: UITableViewCell, Skeletonable {
    
    // MARK: - View Model
    
    struct ViewModel {
        var title: String
        var count: String
        var isSelected: Bool
        var isEditMode: Bool
    }
    
    // MARK: - Properties
    
    private var holderLeadingConstraint: NSLayoutConstraint?

    private let holder: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.99, green: 0.99, blue: 0.99, alpha: 1)
        view.clipsToBounds = false
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.05
        view.layer.shadowOffset = .init(width: 0, height: 2)
        return view
    }()
    
    private let countLabel: UILabel = {
        let view = UILabel()
        view.textColor = .accentColor
        view.font = UIFont.systemFont(ofSize: 24)
        view.textAlignment = .right
        view.minimumScaleFactor = 0.5
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.textColor = .primaryText
        view.font = UIFont.systemFont(ofSize: 17)
        view.numberOfLines = 0
        return view
    }()
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.76, green: 0.76, blue: 0.76, alpha: 1)
        return view
    }()
    
    private lazy var checkBox: CheckBox = {
        let view = CheckBox()
        view.valueChanged = { [unowned self ] isChecked in
            self.modelSelected?(isChecked)
        }
        return view
    }()
    
    private lazy var incrementorView: IncrementorView = {
        let view = IncrementorView()
        view.incremented = { [unowned self] in
            self.incremented?()
        }
        view.decremented = { [unowned self] in
            self.decremented?()
        }
        return view
    }()
    
    static let id = "CounterCell"
    
    var viewModel: CounterCell.ViewModel! {
        didSet {
            titleLabel.text = viewModel.title
            countLabel.text = viewModel.count
            
            if viewModel.isSelected {
                checkBox.check()
            } else {
                checkBox.uncheck()
            }
            
            if viewModel.isEditMode {
                holderLeadingConstraint?.constant = 60
            } else {
                holderLeadingConstraint?.constant = 12
            }
        }
    }
    
    var incremented: (() -> ())?
    var decremented: (() -> ())?
    var modelSelected: ((_ isSelected: Bool) -> ())?
    
    // MARK: - Initicalization
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension CounterCell {
    func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.addSubview(checkBox)
        contentView.addSubview(holder)
        holder.addSubview(countLabel)
        holder.addSubview(incrementorView)
        holder.addSubview(titleLabel)
        holder.addSubview(line)
        setupConstraints()
    }
    
    func setupConstraints() {
        checkBox.autoPinEdge(toSuperviewEdge: .leading, withInset: 13)
        checkBox.autoAlignAxis(.horizontal, toSameAxisOf: contentView, withOffset: -6)
        
        holderLeadingConstraint = holder.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        holder.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        holder.autoPinEdge(toSuperviewEdge: .top, withInset: 4)
        holder.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16)
        
        line.autoPinEdge(toSuperviewEdge: .top)
        line.autoPinEdge(toSuperviewEdge: .bottom)
        line.autoPinEdge(toSuperviewEdge: .leading, withInset: 60)
        line.autoSetDimension(.width, toSize: 1)
        
        countLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 10)
        countLabel.autoPinEdge(.trailing, to: .leading, of: line, withOffset: -10)
        countLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 10)
        
        titleLabel.autoPinEdge(.leading, to: .trailing, of: line, withOffset: 10)
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 13)
        titleLabel.autoPinEdge(toSuperviewEdge: .trailing, withInset: 14)
        
        incrementorView.autoPinEdge(toSuperviewEdge: .bottom, withInset: 14)
        incrementorView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 14)
        incrementorView.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 17)
    }
}

// MARK: - Public

extension CounterCell {
    func updateEditMode(isEdit: Bool, animated: Bool) {
        if isEdit {
            holderLeadingConstraint?.constant = 60
        } else {
            holderLeadingConstraint?.constant = 12
        }
        
        guard animated else { return }
        
        UIView.animate(withDuration: 0.3) {
            self.layoutIfNeeded()
        } completion: { _ in }
    }
}
