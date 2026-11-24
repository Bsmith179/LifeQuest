//
//  QuestBoardUITest.swift
//  LifeQuest
//
//  Created by Icy on 11/24/26.
//

import XCTest

final class QuestBoardUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    //MARK: - Test 3: Incorrect Path (Validation & Duplicate quest Alert)
    func testAddQuest_EnforcesValidationAndBlocksDuplicates(){
        app.launchArguments.append("-UITest_DefaultState")
        app.launch()
        
        let questBoard = DashboardPage(app: app).navigateToQuestBoard()
        let addSheet = questBoard.tapAddQuest()
        
        //1. Save should be disabled when form is empty
        XCTAssertFalse(addSheet.saveButton.isEnabled, "Save should be disabled")
        
        //2. Typing only a title should still keep Save disabled
        addSheet.typeTitle("Morning Walk")
        XCTAssertFalse(addSheet.saveButton.isEnabled, "Save should be disabled with only a title")
        
        //3. Selecting a category enables Save
        addSheet.toggleCategory("Strength")
        XCTAssertTrue(addSheet.saveButton.isEnabled, "Save should be enabled after a category is selected")
        addSheet.tapSave()
        
        //4. attempting to create a duplicate quest triggers the alert
                let duplicateSheet = questBoard.tapAddQuest()
                duplicateSheet
                    .typeTitle("Morning Walk")
                    .toggleCategory("Strength")
                duplicateSheet.tapSave()
                
                print(app.debugDescription)
                XCTAssertTrue(duplicateSheet.invalidQuestAlertOKButton.waitForExistence(timeout: 2.0), "Duplicate quest alert should be visible")
                duplicateSheet.invalidQuestAlertOKButton.tap()
                duplicateSheet.tapCancel()
        
    }
    
}
