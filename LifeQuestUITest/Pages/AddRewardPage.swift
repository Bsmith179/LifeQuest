//
//  AddRewardPage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//


import XCTest
 
 
 
 
struct AddRewardPage {
 
    let app: XCUIApplication
 
    
 
    //MARK: - Locators
 
    var titleField: XCUIElement {
 
        app.textFields["RewardTitleTextField"]
 
    }
 
    
 
    var costStepper: XCUIElement {
 
        app.steppers["RewardCostStepper"]
 
    }
 
    
 
    var saveButton: XCUIElement {
 
        app.buttons["SaveAddRewardButton"]
 
    }
 
    
 
    var cancelButton: XCUIElement {
 
        app.buttons["CancelAddRewardButton"]
 
    }
 
    
 
    var duplicateRewardAlertOKButton: XCUIElement {
 
        app.buttons["DuplicateRewardOKButton"]
 
    }
 
    
 
    //MARK: - Actions
 
    @discardableResult
 
    func typeTitle(_ title: String) -> AddRewardPage {
 
        titleField.tap()
 
        titleField.typeText(title)
 
        return self
 
    }
 
    
 
    @discardableResult
 
    func incrementCost(times: Int = 1)-> AddRewardPage {
 
        let incrementButton = costStepper.buttons["Increment"]
 
        for _ in 0..<times {
 
            incrementButton.tap()
 
        }
 
        return self
 
        
 
    }
 
    
 
    func tapSave()->ShopPage {
 
        saveButton.tap()
 
        return ShopPage(app: app)
 
    }
 
    
 
    func tapCancel()-> ShopPage {
 
        cancelButton.tap()
 
        return ShopPage(app: app)
 
    }
 
    
 
    @discardableResult
 
    func tapDuplicateAlertOK()-> AddRewardPage {
 
        duplicateRewardAlertOKButton.tap()
 
        return self
 
    }
 
}