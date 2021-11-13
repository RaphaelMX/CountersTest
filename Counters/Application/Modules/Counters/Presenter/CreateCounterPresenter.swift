//
//  CreateCounterPresenter.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import Foundation

protocol CreateCounterViewDelegate: AnyObject {
    func counterAdded()
    func show(error: String)
}

internal final class CreateCounterPresenter {
    
    // MARK: - Properties
    
    private let service: CounterServiceProtocol
    private weak var delegate: CreateCounterViewDelegate?
 
    // MARK: - Initialization
    
    init(with service: CounterServiceProtocol) {
        self.service = service
    }
}

// MARK: - Private

private extension CreateCounterPresenter {
    func saveCounterLocally(_ counter: CounterModel) {
        CDManager.shared.add(counter)
        delegate?.counterAdded()
    }
    
    func saveCounterInServer(with newModel: CounterModel) {
        service.makeRequest(with: .addCounter(["title": newModel.title])) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .failure:
                SyncManager.shared.add(newModel)
                self.delegate?.counterAdded()
                
            case .success(let counters):
                if let recent = counters.last {
                    recent.pendingType = PendingType.none
                    CDManager.shared.update(recent)
                }
                self.delegate?.counterAdded()
            }
        }
    }
}

// MARK: - Public

extension CreateCounterPresenter: CreateCounterControllerPresenter {
    func saveNewCounter(with title: String) {
        guard !CDManager.shared.titleExists(title) else {
            delegate?.show(error: "COUNTER_TITLE_EXISTS".localized)
            return
        }
        let newCounter = CounterModel(id: "", title: title, count: 0, pendingType: .save)
        saveCounterLocally(newCounter)
        saveCounterInServer(with: newCounter)
    }
    
    func setView(delegate: CreateCounterViewDelegate) {
        self.delegate = delegate
    }
}


