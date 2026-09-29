//
//  TimeProvider.swift
//  LifeQuest
//
//  Created by Icy on 9/29/26.
//

import Foundation

protocol TimeProvider: Sendable {
    var now: Date { get }
}

struct SystemClock: TimeProvider {
    var now: Date {
        Date()
    }
}
