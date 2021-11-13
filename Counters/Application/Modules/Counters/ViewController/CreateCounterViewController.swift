//
//  CreateCounterViewController.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import UIKit

protocol CreateCounterControllerPresenter {
    func saveNewCounter(with title: String)
    func setView(delegate: CreateCounterViewDelegate)
}

class CreateCounterViewController: BaseViewController {
    
    private let presenter: CreateCounterControllerPresenter
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        view.setTitle("SAVE".localized, for: .normal)
        view.addTarget(self, action: #selector(CreateCounterViewController.savePressed), for: .touchUpInside)
        view.setTitleColor(.disableText, for: .normal)
        view.isEnabled = false
        return view
    }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.font = UIFont.systemFont(ofSize: 20)
        view.placeholder = "Cups of coffee"
        view.borderStyle = .none
        view.delegate = self
        view.tintColor = .accentColor
        view.autocorrectionType = .no
        return view
    }()
    
    private let fieldHolder: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.07
        view.layer.shadowOffset = .init(width: 0, height: 2)
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .medium)
        view.tintColor = .secondaryText
        view.hidesWhenStopped = true
        return view
    }()
    
    private let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        return view
    }()

    // MARK: - Lifecycle
    
    init(with presenter: CreateCounterControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "CREATE_TITLE".localized
        
        presenter.setView(delegate: self)
        setupBarButtons()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
}

// MARK: - Private

private extension CreateCounterViewController {
    func setupBarButtons() {
        let cancelButton = UIBarButtonItem(title: "CANCEL".localized, style: .plain, target: self, action: #selector(CreateCounterViewController.cancelPressed))
        cancelButton.tintColor = .accentColor
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
    }
    
    func setupViews() {
        view.addSubview(bgView)
        view.addSubview(fieldHolder)
        fieldHolder.addSubview(textField)
        fieldHolder.addSubview(activityIndicator)
        setupConstraints()
    }
    
    func setupConstraints() {
        fieldHolder.autoPinEdge(toSuperviewMargin: .top, withInset: 25)
        fieldHolder.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        fieldHolder.autoPinEdge(toSuperviewEdge: .trailing, withInset: 12)
        fieldHolder.autoSetDimension(.height, toSize: 55)
        
        textField.autoPinEdge(toSuperviewEdge: .top)
        textField.autoPinEdge(toSuperviewEdge: .leading, withInset: 12)
        textField.autoPinEdge(toSuperviewEdge: .bottom)
        textField.autoPinEdge(.trailing, to: .leading, of: activityIndicator, withOffset: -10)
        
        activityIndicator.autoPinEdge(toSuperviewEdge: .trailing, withInset: 18)
        activityIndicator.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        bgView.autoPinEdge(toSuperviewMargin: .top)
        bgView.autoPinEdgesToSuperviewEdges(with: .zero, excludingEdge: .top)
    }
    
    func enableSaveButton(enable: Bool) {
        if enable {
            saveButton.setTitleColor(.accentColor, for: .normal)
            saveButton.isEnabled = true
        } else {
            saveButton.setTitleColor(.disableText, for: .normal)
            saveButton.isEnabled = false
        }
    }
}

private extension CreateCounterViewController {
    @objc private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func savePressed() {
        if let title = textField.text {
            activityIndicator.startAnimating()
            enableSaveButton(enable: false)
            presenter.saveNewCounter(with: title)
        }
    }
}

// MARK: - Text Field

extension CreateCounterViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text, let range = Range(range, in: oldText) {
            let newString = oldText.replacingCharacters(in: range, with: string)
            enableSaveButton(enable: newString.count > 0)
        }
        return true
    }
}

// MARK: - View Delegate

extension CreateCounterViewController: CreateCounterViewDelegate {
    func counterAdded() {
        activityIndicator.stopAnimating()
        dismiss(animated: true, completion: nil)
    }
    
    func show(error: String) {
        showAlert(message: error)
    }
}
