//
//  CountersViewController.swift
//  Counters
//
//  Created by Rafael Jimeno on 08/11/21.
//

import UIKit

protocol CountersViewControllerPresenter {
    var modelCount: Int { get }
    var showEmpty: Bool { get }
    var hasFilterResults: Bool { get }
    var totalCountTitle: String { get }
    var isLoading: Bool { get }
    
    func setView(delegate: CountersViewPresenterDelegate)
    func getCounters()
    func filter(by text: String)
    func model(at index: Int) -> CounterCell.ViewModel
    func increment(at indexPath: IndexPath)
    func decrement(at indexPath: IndexPath)
    func updateModelForDeletion(with index: Int)
    func resetModelForDeleteion()
    func deleteModelsSelected()
    func updateCellModels(editMode: Bool)
    func resetCellModelSelection()
}

class CountersViewController: BaseViewController {
    
    // MARK: - Properties
    
    private lazy var actionBottomView = ActionBottomView(withDelegate: self)
    private let presenter: CountersViewControllerPresenter
    
    private let refreshControl: UIRefreshControl = {
        let view = UIRefreshControl()
        view.tintColor = .secondaryText
        view.addTarget(self, action: #selector(CountersViewController.loadItems), for: .valueChanged)
        return view
    }()
    
    private lazy var emptyView: CountersEmptyView = {
        let view = CountersEmptyView()
        view.isHidden = true
        view.addAction = { [unowned self] in
            self.createNewCounter()
        }
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        view.register(CounterCell.self, forCellReuseIdentifier: CounterCell.id)
        view.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        view.refreshControl = refreshControl
        return view
    }()
    
    private lazy var editButton: UIButton = {
        let view = UIButton()
        view.setTitle("EDIT".localized, for: .normal)
        view.addTarget(self, action: #selector(CountersViewController.editPressed), for: .touchUpInside)
        view.setTitleColor(.disableText, for: .normal)
        view.isEnabled = false
        view.titleLabel?.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let noResultsLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 20)
        view.textColor = .secondaryText
        view.text = "NO_RESULTS".localized
        view.isHidden = true
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: editButton)
        
        setupLargeTitle(with: "COUNTERS_TITLE".localized, searchUpdater: self)
        setupViews()
        presenter.setView(delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadItems()
    }
    
    init(with presenter: CountersViewControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension CountersViewController {
    private func setupViews() {
        view.addSubview(emptyView)
        view.addSubview(tableView)
        view.addSubview(actionBottomView)
        view.addSubview(noResultsLabel)
        setupConstraits()
    }
    
    private func setupConstraits() {
        actionBottomView.autoPinEdge(toSuperviewEdge: .bottom)
        actionBottomView.autoPinEdge(toSuperviewEdge: .leading)
        actionBottomView.autoPinEdge(toSuperviewEdge: .trailing)
        
        emptyView.autoPinEdge(toSuperviewEdge: .leading, withInset: 35)
        emptyView.autoPinEdge(toSuperviewEdge: .trailing, withInset: 35)
        emptyView.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        noResultsLabel.autoAlignAxis(toSuperviewAxis: .vertical)
        noResultsLabel.autoAlignAxis(toSuperviewAxis: .horizontal)
        
        tableView.autoPinEdge(toSuperviewMargin: .top)
        tableView.autoPinEdge(toSuperviewEdge: .leading)
        tableView.autoPinEdge(toSuperviewEdge: .trailing)
        tableView.autoPinEdge(.bottom, to: .top, of: actionBottomView)
    }
    
    @objc private func loadItems() {
        presenter.getCounters()
    }
    
    private func createNewCounter() {
        let service = CounterService(with: Networking())
        let controller = CreateCounterViewController(with: CreateCounterPresenter(with: service))
        let navBar = UINavigationController(rootViewController: controller)
        navBar.modalTransitionStyle = .coverVertical
        navBar.modalPresentationStyle = .fullScreen
        present(navBar, animated: true, completion: nil)
    }
    
    private func enableEditButton(enable: Bool) {
        let color: UIColor = enable ? .accentColor: .disableText
        editButton.isEnabled = enable
        editButton.setTitleColor(color, for: .normal)
    }
}

private extension CountersViewController {
    @objc private func editPressed() {
        presenter.resetModelForDeleteion()
        editButton.isSelected = !editButton.isSelected
        
        let title = editButton.isSelected ? "DONE".localized : "EDIT".localized
        editButton.setTitle(title, for: .normal)
        actionBottomView.update(editEnabled: editButton.isSelected)
        presenter.updateCellModels(editMode: editButton.isSelected)
        presenter.resetCellModelSelection()
        
        for i in 0..<presenter.modelCount {
            if let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? CounterCell {
                cell.updateEditMode(isEdit: editButton.isSelected, animated: true)
            }
        }
    }
}

// MARK: - Action Bottom View
extension CountersViewController: ActionBottomViewDelegate {
    func addPressed() {
        createNewCounter()
    }
    
    func deletePressed() {
        presenter.deleteModelsSelected()
    }
}

// MARK: - Search

extension CountersViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        editButton.isSelected = true
        editPressed()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.filter(by: "")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.filter(by: searchText)
    }
}

// MARK: - View Delegate

extension CountersViewController: CountersViewPresenterDelegate {
    func updateUI() {
        emptyView.isHidden = !presenter.showEmpty
        enableEditButton(enable: !presenter.showEmpty)
        noResultsLabel.isHidden = presenter.hasFilterResults
        actionBottomView.title = presenter.totalCountTitle
        refreshControl.endRefreshing()
        tableView.reloadData()
    }
    
    func showError(with message: String) {
        ErrorMessageManager.shared.show(message: message) { [unowned self] in
            self.presenter.deleteModelsSelected()
        }
    }
}

// MARK: - Table View

extension CountersViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.modelCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = presenter.model(at: indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CounterCell.id, for: indexPath) as! CounterCell
        cell.removeSkeletonView()
        cell.viewModel = model
        
        cell.incremented = { [unowned self] in
            self.presenter.increment(at: indexPath)
        }
        
        cell.decremented = { [unowned self] in
            self.presenter.decrement(at: indexPath)
        }
        
        cell.modelSelected = { [unowned self] isSelected in
            self.presenter.updateModelForDeletion(with: indexPath.row)
        }
        return cell
    }
}
