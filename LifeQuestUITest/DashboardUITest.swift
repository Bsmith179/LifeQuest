//
//  DashboardUITest.swift
//  LifeQuest
//
//  Created by Icy on 11/24/26.
//

import XCTest

final class DashboardUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-UITest_DefaultState")
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    //MARK: - Test 1: Sanity Check (Environment & Initial State)
    func testDashboardLaunch_DisplaysCleanDefaultState(){
        let dashboard = DashboardPage(app: app)
        
        //verify deterministic reset worked
        XCTAssertTrue(dashboard.levelLabel.waitForExistence(timeout: 2.0), "Level label not found")
        XCTAssertEqual(dashboard.levelLabel.label, "Level: 1", "Level label value is not 1")
        XCTAssertEqual(dashboard.goldLabel.label, "Gold: 0", "Gold label value is not 0")
        
        //Verify stat meters exist in the accessibility tree
        XCTAssertTrue(dashboard.xpMeter.exists, "XP Meter should exist")
        XCTAssertTrue(dashboard.strengthMeter.exists, "Strength Meter should exist")
        XCTAssertTrue(dashboard.intelligenceMeter.exists, "Intelligence Meter should exist")
        XCTAssertTrue(dashboard.charismaMeter.exists, "Charisma Meter should exist")
        XCTAssertTrue(dashboard.focusMeter.exists, "Focus Meter should exist")
    }
    
}
