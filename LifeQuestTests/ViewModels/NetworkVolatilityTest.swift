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
    
    //MARK: - 500 Series Errors
    
    @Test("Gracefully handles 500 Internal Server Error")
    func testSync_Returns500_MaintainsPendingStatus() async {
        //Arrange
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil)!
            return (response, nil)
            
        }
        sut.createNewQuest(title: "Test Quests", categories: [.strength], difficulty: 2.0, frequency: .oneOff)
        
        //Act
        await sut.syncPendingQuests()
        
        //Assert
        #expect(sut.activeQuests.first?.syncStatus == SyncStatus.pending)
        
    }
}
