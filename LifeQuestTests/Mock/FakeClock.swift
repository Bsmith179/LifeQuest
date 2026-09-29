//
//  FakeClock.swift
//  LifeQuest
//
//  Created by Icy on 9/29/26.
//

import Foundation
@testable import LifeQuest

final class FakeClock: TimeProvider, @unchecked Sendable{
    var now: Date
    
    init(currentDate: Date) {
        self.now = currentDate
    }
}
