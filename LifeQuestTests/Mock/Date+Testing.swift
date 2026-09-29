//
//  Date+Testing.swift
//  LifeQuest
//
//  Created by Icy on 9/29/26.
//

import Foundation

extension Date {
    // Locks in exactly "Now" but strips minutes/seconds for perfect determinism
    static let testEpoch: Date = {
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour], from: Date())
        return Calendar.current.date(from: components)!
    }()
    
    // Generates test dates offset from the deterministic 'Now'
    static func testDate(dayOffset: Int, hourOffset: Int = 0) -> Date {
        var components = DateComponents()
        components.day = dayOffset
        components.hour = hourOffset
        return Calendar.current.date(byAdding: components, to: testEpoch)!
    }
}
