//
//  ChangeDatePage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//

import XCTest




struct ChangeDatePage {
    
    let app: XCUIApplication
    
    
    
    //MARK: - Locators
    
    var hasStartDateToggle: XCUIElement {
        
        app.switches["HasStartDateToggle"]
        
    }
    
    
    
    var startDatePicker: XCUIElement {
        
        app.datePickers["StartDatePicker"]
        
    }
    
    
    
    var hasEndDateToggle: XCUIElement {
        
        app.switches["HasEndDateToggle"]
        
    }
    
    
    
    var endDatePicker: XCUIElement {
        
        app.datePickers["EndDatePicker"]
        
    }
    
    
    
    var saveButton: XCUIElement {
        
        app.buttons["SaveChangeDateButton"]
        
    }
    
    
    
    var cancelButton: XCUIElement {
        
        app.buttons["CancelChangeDateButton"]
        
    }
    
    
    
    //MARK: - Actions
    
    @discardableResult
    func toggleStartDate() -> ChangeDatePage{
        tapToggle(hasStartDateToggle)
        return self
    }
    
    @discardableResult
    func toggleEndDate() -> ChangeDatePage{
        tapToggle(hasEndDateToggle)
        return self
    }
    
    func tapSave(){
        
        saveButton.tap()
        
    }
    
    func tapCancel(){
        
        cancelButton.tap()
        
    }
    
    //MARK: - Helpers
    private func tapToggle(_ toggle: XCUIElement){
        let innerSwitch = toggle.switches.firstMatch
        if innerSwitch.exists {
            innerSwitch.tap()
        } else {
            toggle.coordinate(withNormalizedOffset: CGVector(dx: 0.9, dy: 0.5)).tap()
        }
    }
}
