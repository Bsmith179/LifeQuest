//
//  ShopPage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//


import XCTest




struct ShopPage{
    
    let app: XCUIApplication
    
    
    
    //MARK: - Locators
    
    var navigationTitle: XCUIElement {
        
        app.navigationBars["Reward Shop"]
        
    }
    
    
    
    var addRewardButton: XCUIElement {
        
        app.buttons["AddRewardButton"]
        
    }
    
    
    
    var availableGoldLabel: XCUIElement {
        
        app.staticTexts.containing(NSPredicate(format: "label BEGINSWITH 'Abailable Gold:'")).firstMatch
        
    }
    
    
    
    var insufficientGoldAlertOKButton: XCUIElement {
        
        app.buttons["InsufficientGoldOKButton"]
        
    }
    
    
    
    //Dynamic Locator
    
    func buyButton(forReward title: String)-> XCUIElement {
        
        app.buttons["BuyButton_\(title)"]
        
    }
    
    
    
    //MARK: - Actions
    
    func tapAddReward() -> AddRewardPage {
        
        addRewardButton.tap()
        
        return AddRewardPage(app: app)
        
    }
    
    
    
    @discardableResult
    func tapBuy(forReward title: String)->ShopPage{
        
        let button = buyButton(forReward: title)
        
        button.tap()
        
        return self
        
    }
    
    @discardableResult
    func tapBackToDashboard() -> DashboardPage {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return DashboardPage(app: app)
    }
}
