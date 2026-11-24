//
//  AddQuestPage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//

import XCTest




struct AddQuestPage {
    
    let app: XCUIApplication
    
    
    
    //MARK: - Locators
    
    var titleField: XCUIElement {
        
        app.textFields["QuestTitleTextField"]
        
    }
    
    
    
    var frequencyPicker: XCUIElement {
        
        app.pickers["QuestFrequencyPicker"]
        
    }
    
    
    
    var difficultyStepper: XCUIElement {
        
        app.steppers["QuestDifficultyStepper"]
        
    }
    
    
    
    var setCustomDatesButton: XCUIElement {
        
        app.buttons["SetCustomDatesButton"]
        
    }
    
    
    
    var saveButton: XCUIElement {
        
        app.buttons["SaveAddQuestButton"]
        
    }
    
    
    
    var cancelButton: XCUIElement {
        
        app.buttons["CancelAddQuestButton"]
        
    }
    
    
    
    var invalidQuestAlertOKButton: XCUIElement {
        
        app.buttons["InvalidQuestAlertOKButton"].firstMatch
        
    }
    
    
    
    //Dynamic Locator for stat categories
    
    func categoryToggle(_ category: String)-> XCUIElement {
        
        app.switches["Category\(category)Toggle"]
        
    }
    
    
    
    //MARK: - Navigation Actions
    
    func tapSetCustomDates()-> ChangeDatePage {
        
        setCustomDatesButton.tap()
        
        return ChangeDatePage(app: app)
        
    }
    
    
    @discardableResult
    func tapSave() -> QuestBoardPage {
        
        saveButton.tap()
        
        return QuestBoardPage(app: app)
        
    }
    
    
    @discardableResult
    func tapCancel() -> QuestBoardPage {
        
        cancelButton.tap()
        
        return QuestBoardPage(app: app)
        
    }
    
    //MARK: - Actions
    @discardableResult
    func typeTitle(_ title: String) -> AddQuestPage {
        titleField.tap()
        titleField.typeText(title)
        return self
    }
    
    @discardableResult
    func toggleCategory(_ category: String) -> AddQuestPage {
        let toggle = categoryToggle(category)
        let innerSwitch = toggle.switches.firstMatch
        
        if innerSwitch.exists {
            innerSwitch.tap()
        } else {
            toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        }
        return self
    }
    
}
