//
//  SyncManager.swift
//  Counters
//
//  Created by Rafael Jimeno on 10/11/21.
//

import Foundation

fileprivate struct PendingQueue<Item> {
    private var list: [Item] = [Item]()
    
    var isEmpty: Bool {
        return list.isEmpty
    }
    
    var count: Int {
        return list.count
    }
    
    mutating func enqueue(element: Item) {
        list.append(element)
    }
    
    mutating func dequeue() -> Item? {
        if list.isEmpty {
            return nil
        } else{
            let tempElement = list.first
            list.remove(at: 0)
            return tempElement
        }
    }
}

class SyncManager {
    
    // MARK: - Properties
    private var queue = PendingQueue<CounterModel>()
    private var isActive = false
    private var attempts = 0
    private var service: CounterService
    
    static let shared = SyncManager()
    
    // MARK: - Initialization
    private init() {
        service = CounterService(with: Networking())
    }
}

// MARK: - Private

private extension SyncManager {
    func router(from model: CounterModel) -> CountersRouter? {
        var router: CountersRouter?
        if model.pendingType == .save {
            router = .addCounter(["title": model.title])
            
        } else if model.pendingType == .decrement {
            router = .decrement(["id": model.id])
            
        } else if model.pendingType == .increment {
            router = .increment(["id": model.id])
        }
        
        return router
    }
    
    func upload(_ model: CounterModel) {
        if let router = router(from: model) {
            service.makeRequest(with: router) { [unowned self] result in
                switch result {
                case .failure(let error):
                    print("Error: \(error.localizedDescription)")
                    if self.attempts >= 2 {
                        self.attempts = 0
                        
                    } else {
                        self.attempts += 1
                        self.add(model)
                        self.takeNext()
                    }
                    
                case .success(let counters):
                    if let modifiedCounter = counters.first(where: { $0.id == model.id }) {
                        modifiedCounter.pendingType = PendingType.none
                        CDManager.shared.update(modifiedCounter)
                    }
                }
            }
        }
    }
    
    func takeNext() {
        guard isActive else { return }
        
        if let counter = queue.dequeue() {
            print("Next model dequeued")
            upload(counter)
        } else {
            print("Sync Manager Finished Uploading")
            isActive = false
        }
    }
    
    func startSyncupIfNeeded() {
        if !isActive {
            isActive = true
            attempts = 0
            takeNext()
        }
    }
}

// MARK: - Public

extension SyncManager {
    func loadPendingModels() {
        if let counters = CDManager.shared.loadCounters()?.filter({ $0.pendingType != PendingType.none }),
           counters.count > 0 {
            add(counters)
        }
    }
    
    func add(_ model: CounterModel) {
        queue.enqueue(element: model)
        startSyncupIfNeeded()
    }
    
    func add(_ models: [CounterModel]) {
        for model in models {
            queue.enqueue(element: model)
        }
        startSyncupIfNeeded()
    }
    
    func pause() {
        isActive = false
    }
    
    func resume() {
        isActive = true
        startSyncupIfNeeded()
    }
}
