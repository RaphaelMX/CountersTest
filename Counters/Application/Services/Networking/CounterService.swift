//
//  CounterService.swift
//  Counters
//
//  Created by Rafael Jimeno on 10/11/21.
//

import Foundation

// MARK: - Service contract

protocol CounterServiceProtocol {
    func makeRequest(with router: CountersRouter, response: @escaping CountersResponse)
}

typealias CountersResponse = (Result<[CounterModel], Error>) -> Void

struct CounterService {
    // MARK: - Properties
    
    private let client: Networking
    
    // MARK: - Initialization
    
    init(with client: Networking) {
        self.client = client
    }
}

// MARK: - Private

private extension CounterService {
    func parse(_ json: [[String: Any]]?) -> [CounterModel]? {
        if let data = json, let jsonData = try? JSONSerialization.data(withJSONObject: data, options: .prettyPrinted) {
            let counters = try! JSONDecoder().decode([CounterModel].self, from: jsonData)
            return counters
        }
        return nil
    }
}

// MARK: - Service protocol

extension CounterService: CounterServiceProtocol {
    func makeRequest(with router: CountersRouter, response: @escaping CountersResponse) {
        if let url = URL(string: router.endpoint) {
            client.jsonRequest(url,
                               httpMethod: router.method,
                               parameters: router.parameters)
            { data, error in
                if let error = error {
                    DispatchQueue.main.async {
                        response(.failure(error))
                    }
                    return
                }
                
                if let json = data as? [[String: Any]] {
                    let counters = parse(json) ?? []
                    
                    DispatchQueue.main.async {
                        response(.success(counters))
                    }
                }
            }.resume()
        }
    }
}
