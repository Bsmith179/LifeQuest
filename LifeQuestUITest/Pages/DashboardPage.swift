//
//  DashboardPage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//

import XCTest
 
struct DashboardPage {
    let app: XCUIApplication
    
    // MARK: - Locators
    var questBoardButton: XCUIElement { app.buttons["QuestBoardViewButton"] }
    var shopButton: XCUIElement { app.buttons["ShopViewButton"] }
    
    var levelLabel: XCUIElement { app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Level:'")).firstMatch }
    var goldLabel: XCUIElement { app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Gold:'")).firstMatch }
    
    var xpMeter: XCUIElement { app.staticTexts["XP"] }
    var strengthMeter: XCUIElement { app.staticTexts["Strength"] }
    var focusMeter: XCUIElement { app.staticTexts["Focus"] }
    var intelligenceMeter: XCUIElement { app.staticTexts["Intelligence"] }
    var charismaMeter: XCUIElement { app.staticTexts["Charisma"] }
    
    // MARK: - Actions
    @discardableResult
    func navigateToQuestBoard() -> QuestBoardPage {
        questBoardButton.tap()
        return QuestBoardPage(app: app)
    }
    
    @discardableResult
    func navigateToShop() -> ShopPage {
        shopButton.tap()
        return ShopPage(app: app)
    }
}
