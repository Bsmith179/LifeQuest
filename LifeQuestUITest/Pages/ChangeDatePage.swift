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
 
        app.switches["hasStartDateToggle"]
 
    }
 
    
 
    var startDatePicker: XCUIElement {
 
        app.datePickers["StartDatePicker"]
 
    }
 
    
 
    var hasEndDateToggle: XCUIElement {
 
        app.switches["hasEndDateToggle"]
 
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
 
    func tapSave(){
 
        saveButton.tap()
 
    }
 
    
 
    func tapCancel(){
 
        cancelButton.tap()
 
    }
 
}
