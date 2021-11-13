//
//  Router.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import Foundation

typealias APIParameters = [String: String]

protocol APIRouter {
    var baseURL: String { get }
    var endpoint: String { get }
    var method: String { get }
    var headers: [String: Any] { get }
    var parameters: APIParameters? { get }
}

extension APIRouter {
    var currentVersion: String {
        return "/api/v1"
    }
    
    var headers: [String: Any] {
        return ["ContentType": "application/json"]
    }
    
    var baseURL: String {
        return "http://localhost:3000\(currentVersion)"
    }
}
