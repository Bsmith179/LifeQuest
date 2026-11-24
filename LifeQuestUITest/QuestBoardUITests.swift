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
    
    // MARK: - Test 4: Happy Path (Create Quest & View Details)
    func testCreateQuest_AppearsOnBoardAndOpensDetails() {
        app.launchArguments.append("-UITest_DefaultState")
        app.launch()
        
        let questBoard = DashboardPage(app: app).navigateToQuestBoard()
        let title = "Read 20 Pages"
        
        questBoard.tapAddQuest()
            .typeTitle(title)
            .toggleCategory("Intelligence")
            .tapSave()
        
        // Verify row appears, then open Detail Sheet
        XCTAssertTrue(questBoard.questRow(forQuest: title).waitForExistence(timeout: 2.0))
        let detailSheet = questBoard.tapQuestRow(forQuest: title)
        
        XCTAssertTrue(detailSheet.closeButton.waitForExistence(timeout: 2.0), "Detail sheet should open.")
        detailSheet.tapClose()
        
        XCTAssertTrue(questBoard.navigationTitle.waitForExistence(timeout: 2.0), "Should return to Quest Board.")
    }
    
    // MARK: - Test 5: Conditional UI (Modifying Dates)
    func testChangeDateToggles_RevealDatePickers() {
        app.launchArguments.append("-UITest_DefaultState")
        app.launch()
        
        let questBoard = DashboardPage(app: app).navigateToQuestBoard()
        let addSheet = questBoard.tapAddQuest()
        let dateSheet = addSheet.tapSetCustomDates()
        
        // Pickers should not exist until toggles are switched on
        XCTAssertFalse(dateSheet.startDatePicker.exists, "Start DatePicker should be hidden initially.")
        XCTAssertFalse(dateSheet.endDatePicker.exists, "End DatePicker should be hidden initially.")
        
        dateSheet.toggleStartDate()
        XCTAssertTrue(dateSheet.startDatePicker.waitForExistence(timeout: 2.0), "Start DatePicker should appear.")
        
        dateSheet.toggleEndDate()
        XCTAssertTrue(dateSheet.endDatePicker.waitForExistence(timeout: 2.0), "End DatePicker should appear.")
        dateSheet.tapSave()
    }
    
    // MARK: - Test 6: Lifecycle Transitions (Recommit & Abandon)
    func testQuestLifecycle_RecommitOpensDateSheetAndAbandonRemovesQuest() {
        app.launchArguments.append("-UITest_MockAbandonedQuest")
        app.launch()
        
        let questBoard = DashboardPage(app: app).navigateToQuestBoard()
        let mockTitle = "Test Quest"
        
        // 1. Recommit -> Opens ChangeDatePage, then Cancel returns to Quest Board
        let dateSheet = questBoard.tapRecommit(forQuest: mockTitle)
        XCTAssertTrue(dateSheet.cancelButton.waitForExistence(timeout: 2.0),
                      "Recommit should open ChangeDatePage.")
        dateSheet.tapCancel()
        
        XCTAssertTrue(questBoard.navigationTitle.waitForExistence(timeout: 2.0),
                      "Should return to Quest Board after canceling.")
        
        
        // 2. Abandon -> Quest disappears from the active list
        questBoard.tapAbandon(forQuest: mockTitle)
        XCTAssertFalse(questBoard.completeButton(forQuest: mockTitle).exists,
                       "Complete button should disappear after abandoning.")
        XCTAssertFalse(questBoard.recommitButton(forQuest: mockTitle).exists,
                       "Recommit button should disappear after abandoning.")
        
    }
}
