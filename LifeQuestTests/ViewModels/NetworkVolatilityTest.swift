//
//  NetworkVolatilityTest.swift
//  LifeQuestTests
//
//  Created by Icy on 10/13/26.
//

import Testing
import Foundation
@testable import LifeQuest
@MainActor

struct NetworkVolatilityTest {

    let fakeClock: FakeClock
    let sut: QuestViewModel
    
    init(){
        fakeClock = FakeClock(currentDate: Date.testEpoch)
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let hijackSession = URLSession(configuration: config)
        sut = QuestViewModel(clock: fakeClock, session: hijackSession)
    }
}
