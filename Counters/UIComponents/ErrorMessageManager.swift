//
//  ErrorMessageManager.swift
//  Counters
//
//  Created by Rafael Jimeno on 12/11/21.
//

import UIKit

class ErrorMessageManager: NSObject {

    // MARK: - Properties
    
    static let shared = ErrorMessageManager()
    private var errorView: ErrorMessageView?
    private var canceled = false
    
    // MARK: - Initizalization
    
    private override init() {}
}

// MARK: - Private

private extension ErrorMessageManager {
    private func showView() {
        UIView.animate(withDuration: 0.3) {
            self.errorView?.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 0)
        } completion: { done in
            self.perform(#selector(ErrorMessageManager.remove), with: nil, afterDelay: 4)
        }
    }
    
    @objc private func remove() {
        guard !canceled else {
            canceled = false
            return
        }
        
        UIView.animate(withDuration: 0.3) {
            self.errorView?.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 120)
        } completion: { done in
            self.errorView?.removeFromSuperview()
            self.errorView = nil
        }
    }
}

// MARK: - Public

extension ErrorMessageManager {
    func show(message: String, handler: @escaping () -> ()) {
        let view = ErrorMessageView(with: message)
        UIApplication.shared.delegate?.window??.addSubview(view)
        
        view.autoPinEdge(toSuperviewEdge: .bottom, withInset: 16 + UIScreen.bottomMargin)
        view.autoPinEdge(toSuperviewEdge: .leading, withInset: 20)
        view.autoPinEdge(toSuperviewEdge: .trailing, withInset: 20)
        view.transform = CGAffineTransform.identity.translatedBy(x: 0, y: 120)
        
        errorView = view
        showView()
        
        view.retryTapped = { [unowned self] in
            self.errorView?.removeFromSuperview()
            self.errorView = nil
            self.canceled = true
            handler()
        }
    }
}

fileprivate class ErrorMessageView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        view.text = "Error"
        view.textColor = .red
        return view
    }()
    
    private let messageLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 14)
        view.numberOfLines = 0
        return view
    }()
    
    private lazy var retryButton: UIButton = {
        let view = UIButton()
        view.setTitle("Retry", for: .normal)
        view.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(ErrorMessageView.retryPressed), for: .touchUpInside)
        view.layer.cornerRadius = 14
        view.backgroundColor = .accentColor
        return view
    }()
    
    var retryTapped: (() -> ())?
    
    // MARK: - Initizalization
    
    init(with message: String) {
        super.init(frame: .zero)
        setupViews()
        messageLabel.text = message
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension ErrorMessageView {
    private func setupViews() {
        layer.cornerRadius = 8
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = .init(width: 0, height: 2)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.07
        clipsToBounds = false
        
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(retryButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.autoPinEdge(toSuperviewEdge: .top, withInset: 12)
        titleLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        
        messageLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 4)
        messageLabel.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        messageLabel.autoPinEdge(.trailing, to: .leading, of: retryButton, withOffset: -10)
        messageLabel.autoPinEdge(toSuperviewEdge: .bottom, withInset: 12)
        
        retryButton.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        retryButton.autoAlignAxis(.horizontal, toSameAxisOf: messageLabel)
        retryButton.autoSetDimensions(to: CGSize(width: 60, height: 28))
    }
}

private extension ErrorMessageView {
    @objc private func retryPressed() {
        retryTapped?()
    }
}
