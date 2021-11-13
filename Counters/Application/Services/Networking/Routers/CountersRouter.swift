//
//  CountersRouter.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import Foundation

enum CountersRouter: APIRouter {
    case getCounters
    case addCounter(APIParameters)
    case deleteCounter(APIParameters)
    case increment(APIParameters)
    case decrement(APIParameters)
    
    var endpoint: String {
        switch self {
        case .getCounters:
            return "\(baseURL)/counters"
            
        case .addCounter, .deleteCounter:
            return "\(baseURL)/counter"
            
        case .increment:
            return "\(baseURL)/counter/inc"
            
        case .decrement:
            return "\(baseURL)/counter/dec"
        }
    }
    
    var parameters: APIParameters? {
        switch self {
        case .getCounters:
            return nil
        case .addCounter(let params), .deleteCounter(let params), .increment(let params), .decrement(let params):
            return params
        }
    }
    
    var method: String {
        switch self {
        case .getCounters:
            return "GET"
            
        case .addCounter, .increment, .decrement:
            return "POST"
            
        case .deleteCounter:
            return "DELETE"
        }
    }
}
