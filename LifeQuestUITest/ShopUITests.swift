//
//  ShopUITests.swift
//  LifeQuest
//
//  Created by Icy on 11/24/26.
//

import XCTest

final class ShopUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Test 7: Incorrect Paths (Validation, Duplicate Reward, Insufficient Gold)
    func testRewardShop_BlocksDuplicatesAndInsufficientGold() {
        app.launchArguments.append("-UITest_DefaultState")
        app.launch()
        
        let shop = DashboardPage(app: app).navigateToShop()
        let addReward = shop.tapAddReward()
        
        // 1. Save disabled when title is empty
        XCTAssertFalse(addReward.saveButton.isEnabled, "Save should be disabled with empty title.")
        
        // 2. Create a 30 Gold reward (starts at 10, +10 twice)
        addReward
            .typeTitle("Coffee Treat")
            .incrementCost(times: 2)
            .tapSave()
        
        // 3. Attempt duplicate reward
        let duplicateSheet = shop.tapAddReward()
        duplicateSheet.typeTitle("Coffee Treat")
        duplicateSheet.saveButton.tap()
        
        XCTAssertTrue(duplicateSheet.duplicateRewardAlertOKButton.waitForExistence(timeout: 2.0))
        duplicateSheet.tapDuplicateAlertOK()
        duplicateSheet.tapCancel()
        
        // 4. Attempt to buy with 0 Gold -> triggers Insufficient Gold alert
        shop.tapBuy(forReward: "Coffee Treat")
        XCTAssertTrue(shop.insufficientGoldAlertOKButton.waitForExistence(timeout: 2.0),
                      "Not Enough Gold alert should appear when gold is 0.")
        shop.tapInsufficientGoldOK()
        
        // Gold should remain unchanged
        XCTAssertEqual(shop.availableGoldLabel.label, "Available Gold: 0")
    }
    
    // MARK: - Test 8: End-to-End Golden Path (Earn Gold -> Spend Gold)
    func testGoldenPath_CompletingQuestFundsRewardPurchase() {
        app.launchArguments.append("-UITest_MockActiveQuest")
        app.launch()
        
        let dashboard = DashboardPage(app: app)
        
        // 1. Complete the mock quest to earn gold
        let questBoard = dashboard.navigateToQuestBoard()
        questBoard.tapComplete(forQuest: "Test Quest")
        questBoard.tapBackToDashboard()
        
        // 2. Verify Dashboard reflects the earned gold (no longer 0)
        XCTAssertNotEqual(dashboard.goldLabel.label, "Gold: 0", "Gold should increase after completing a quest.")
        
        // 3. Navigate to Shop, create an affordable 10 Gold reward, and buy it
        let shop = dashboard.navigateToShop()
        let goldBeforePurchase = shop.availableGoldLabel.label
        
        shop.tapAddReward()
            .typeTitle("Quick Break")
            .tapSave()
        
        shop.tapBuy(forReward: "Quick Break")
        
        // 4. Verify purchase succeeded (no alert, gold label updated)
        XCTAssertFalse(shop.insufficientGoldAlertOKButton.exists, "Should have enough gold to buy a 10 Gold reward.")
        XCTAssertNotEqual(shop.availableGoldLabel.label, goldBeforePurchase, "Available gold should decrease after purchase.")
    }
}
