//
//  CDManager.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import Foundation
import CoreData

class CDManager {
    
    // MARK: - Properties
    
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var moc: NSManagedObjectContext
    
    static let shared = CDManager()
    
    // MARK: - Initialization
    
    private init() {
        moc = appDelegate.persistentContainer.viewContext
    }
}

// MARK: - Private

private extension CDManager {
    func modelExists(with predicate: NSPredicate) -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Counter")
        fetchRequest.predicate = predicate

        var entitiesCount = 0
        do {
            entitiesCount = try moc.count(for: fetchRequest)
        }
        catch {
            print("error executing fetch request: \(error)")
        }
        return entitiesCount > 0
    }
    
    func updateModel(_ model: CounterModel, using predicate: NSPredicate) {
        let fetchRequest = Counter.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let results = try moc.fetch(fetchRequest)
            if let counter = results.first {
                counter.setValue(model.id, forKey: "id")
                counter.setValue(model.pendingType?.rawValue ?? 0, forKey: "pendingType")
                counter.setValue(model.count, forKey: "count")
            }
            saveContext()
            
        } catch {
            print("Error getting counters from core data")
        }
    }
}

// MARK: - Public

extension CDManager {
    func titleExists(_ title: String) -> Bool {
        return modelExists(with: NSPredicate(format: "title = %@", title))
    }
    
    func add(_ counters: [CounterModel]) {
        for model in counters {
            let counter = NSEntityDescription.insertNewObject(forEntityName: "Counter", into: moc)
            counter.setValue(model.title, forKey: "title")
            counter.setValue(model.id, forKey: "id")
            counter.setValue(Int16(model.count), forKey: "count")
        }
        saveContext()
    }
    
    func add(_ model: CounterModel) {
        let counter = Counter(context: moc)
        counter.title = model.title
        counter.id = model.id
        counter.count = Int16(model.count)
        counter.pendingType = Int16((model.pendingType?.rawValue ?? 0))
        saveContext()
    }
    
    func loadCounters() -> [CounterModel]? {
        let countersRequest = Counter.fetchRequest()
        var results: [Counter]?
        
        do {
            try results = moc.fetch(countersRequest)
        } catch {
            print("Error getting counters from core data")
        }
        
        var models = [CounterModel]()
        results?.forEach({ counter in
            models.append(CounterModel(id: counter.id ?? "",
                                       title: counter.title ?? "",
                                       count: Int(counter.count),
                                       pendingType: PendingType(rawValue: Int(counter.pendingType)) ?? PendingType.none))
        })
        
        return models.reversed()
    }
    
    func update(_ model: CounterModel) {
        if modelExists(with: NSPredicate(format: "id = %@", model.id)) {
            updateModel(model, using: NSPredicate(format: "id = %@", model.id))
            
        } else if titleExists(model.title) {
            updateModel(model, using: NSPredicate(format: "title = %@", model.title))
            
        } else {
            add(model)
        }
    }
    
    func delete(_ models: [CounterModel]) {
        for model in models {
            let request = Counter.fetchRequest()
            request.predicate = NSPredicate(format: "title = %@", model.title)
            
            do {
                let results = try moc.fetch(request)
                if let counter = results.first {
                    moc.delete(counter)
                }
            } catch {
                print("Error getting counters from core data")
            }
        }
        saveContext()
    }
    
    func saveContext() {
        appDelegate.saveContext()
    }
}
