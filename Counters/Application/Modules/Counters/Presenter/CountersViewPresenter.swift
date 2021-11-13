//
//  CountersViewPresenter.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import Foundation
import CoreLocation

protocol CountersViewPresenterDelegate: AnyObject {
    func updateUI()
    func showError(with message: String)
}

internal final class CountersViewPresenter {
    
    // MARK: - Properties
    
    private let service: CounterServiceProtocol
    private var counters = [CounterModel]()
    private var cellModels = [CounterCell.ViewModel]()
    private var allCellModels = [CounterCell.ViewModel]()
    private var isFilter = false
    private var _isLoading = true
    private weak var viewDelegate: CountersViewPresenterDelegate?
    private var modelsToDelete = [CounterModel]()
    
    // MARK: - Initialization
    
    init(with service: CounterServiceProtocol) {
        self.service = service
    }
}

// MARK: - Private

private extension CountersViewPresenter {
    func loadItemsFromServer() {
        service.makeRequest(with: .getCounters) { [weak self] result in
            guard let self = self else { return }
            self._isLoading = false
            
            switch result {
            case .failure:
                self.reloadModelsLocally(fromEditMode: false)
            case .success(let counters):
                self.syncupFromServer(counters: counters)
            }
        }
    }
    
    func syncupFromServer(counters: [CounterModel]) {
        let localCounters = CDManager.shared.loadCounters() ?? []
        _isLoading = false
        
        if localCounters.count > 0 {
            updateUI(with: localCounters)
            
        } else {
            if counters.count > 0 {
                CDManager.shared.add(counters)
            }
            self.updateUI(with: counters)
        }
    }
    
    func createCellModels(fromEditMode: Bool = false) {
        self.cellModels.removeAll()
        
        var cellModels = [CounterCell.ViewModel]()
        for counter in counters {
            cellModels.append(CounterCell.ViewModel(title: counter.title,
                                                    count: "\(counter.count)",
                                                    isSelected: false,
                                                    isEditMode: fromEditMode))
        }
        self.allCellModels = cellModels
        self.cellModels = cellModels
    }
    
    func loadCounters() {
        updateUI(with: [])
        loadItemsFromServer()
    }
    
    func updateUI(with counters: [CounterModel]) {
        self.counters = counters
        createCellModels()
        viewDelegate?.updateUI()
    }
    
    func reloadModelsLocally(fromEditMode: Bool) {
        counters = CDManager.shared.loadCounters() ?? []
        createCellModels(fromEditMode: fromEditMode)
        viewDelegate?.updateUI()
    }
    
    func updateCounter(with router: CountersRouter, model: CounterModel) {
        reloadModelsLocally(fromEditMode: false)
        service.makeRequest(with: router) { result in
            switch result {
            case .failure:
                SyncManager.shared.add(model)
                
            case .success:
                model.pendingType = PendingType.none
                CDManager.shared.update(model)
            }
        }
    }
    
    func deleteModelsLocally() {
        CDManager.shared.delete(modelsToDelete)
    }
    
    func deleteFromServer() {
        let group = DispatchGroup()
        var errors = 0
        var results = [CounterModel]()
        
        for model in modelsToDelete {
            group.enter()
            service.makeRequest(with: .deleteCounter(["id": model.id])) { result in
                switch result {
                case .failure:
                    errors += 1
                    
                case .success(let counters):
                    results = counters
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            if errors == 0 {
                self.deleteModelsLocally()
                self.reloadModelsLocally(fromEditMode: true)
                
            } else {
                if errors == self.modelsToDelete.count {
                    self.viewDelegate?.showError(with: "SERVER_ERROR".localized)
                } else {
                    var undeletedModels = self.modelsToDelete
                    for model in self.modelsToDelete {
                        if let index = results.firstIndex(where: { $0.title == model.title }) {
                            undeletedModels.remove(at: index)
                        }
                    }
                    self.modelsToDelete = undeletedModels
                    self.deleteModelsLocally()
                    self.reloadModelsLocally(fromEditMode: true)
                }
            }
        }
    }
}

// MARK: - View Presenter

extension CountersViewPresenter: CountersViewControllerPresenter {
    
    var isLoading: Bool {
        return _isLoading
    }
    
    var modelCount: Int {
        guard !isLoading else {
            return 0
        }
        return cellModels.count
    }
    
    var showEmpty: Bool {
        guard !isLoading, !isFilter else {
            return false
        }
        return modelCount == 0
    }
    
    var hasFilterResults: Bool {
        if isFilter {
            return cellModels.count != 0
        }
        return true
    }
    
    var totalCountTitle: String {
        let totalModelsWithCount = counters.filter { $0.count > 0 }.count
        guard totalModelsWithCount > 0 else {
            return ""
        }
        
        let totalCounts = counters.map { $0.count }.reduce(0, +)
        let suffix = totalCounts == 1 ? "" : "s"
        return "\(totalModelsWithCount) item\(suffix) - Counted \(totalCounts) times"
    }
    
    func setView(delegate: CountersViewPresenterDelegate) {
        self.viewDelegate = delegate
    }
    
    func getCounters() {
        _isLoading = true
        loadCounters()
    }
    
    func filter(by text: String) {
        if text.isEmpty {
            isFilter = false
            cellModels = allCellModels
        } else {
            isFilter = true
            cellModels = allCellModels.filter { $0.title.lowercased().contains(text.lowercased()) }
        }
        viewDelegate?.updateUI()
    }
    
    func model(at index: Int) -> CounterCell.ViewModel {
        return cellModels[index]
    }
    
    func increment(at indexPath: IndexPath) {
        let cellModel = cellModels[indexPath.row]
        
        if let model = counters.first(where: { $0.title == cellModel.title }) {
            model.count += 1
            model.pendingType = .increment
            
            CDManager.shared.update(model)
            updateCounter(with: .increment(["id": model.id]), model: model)
        }
    }
    
    func decrement(at indexPath: IndexPath) {
        let cellModel = cellModels[indexPath.row]
        
        if let model = counters.first(where: { $0.title == cellModel.title }) {
            let canDecrement = model.count == 0 ? false : true
            model.count = model.count > 0 ? model.count - 1 : 0
            model.pendingType = .decrement
            
            CDManager.shared.update(model)
            
            if canDecrement {
                updateCounter(with: .decrement(["id": model.id]), model: model)
            }
        }
    }
    
    func updateModelForDeletion(with index: Int) {
        let cellModel = cellModels[index]
        var isSelected = false
        
        if let model = counters.first(where: { $0.title == cellModel.title }) {
            if let index = modelsToDelete.firstIndex(where: { $0.title == model.title }) {
                modelsToDelete.remove(at: index)
            } else {
                isSelected = true
                modelsToDelete.append(model)
            }
        }
        cellModels[index].isSelected = isSelected
    }
    
    func resetModelForDeleteion() {
        modelsToDelete.removeAll()
    }
    
    func deleteModelsSelected() {
        deleteFromServer()
    }
    
    func updateCellModels(editMode: Bool) {
        for i in 0..<cellModels.count {
            cellModels[i].isEditMode = editMode
        }
    }
    
    func resetCellModelSelection() {
        modelsToDelete.removeAll()
        for i in 0..<cellModels.count {
            cellModels[i].isSelected = false
        }
    }
}


