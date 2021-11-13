//
//  Counter.swift
//  Counters
//
//  Created by Rafael Jimeno on 09/11/21.
//

import Foundation

enum PendingType: Int, Decodable {
    case none = 0,
         save,
         increment,
         decrement
}

class CounterModel: Decodable {
    var id: String
    var title: String
    var count: Int
    var pendingType: PendingType?
    
    init(id: String, title: String, count: Int, pendingType: PendingType?) {
        self.id = id
        self.title = title
        self.count = count
        self.pendingType = pendingType
    }
}
