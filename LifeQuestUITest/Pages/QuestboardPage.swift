//
//  QuestboardPage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//

import XCTest
 
struct QuestBoardPage {
    let app: XCUIApplication
    
    // MARK: - Locators
    var navigationTitle: XCUIElement { app.navigationBars["Quest Board"] }
    var addQuestButton: XCUIElement { app.buttons["AddQuestButton"] }
    
    // MARK: - Dynamic Row Locators
    func questRow(forQuest title: String) -> XCUIElement {
        app.staticTexts["QuestRowBaseInfo_\(title)"].firstMatch
}
 
    func completeButton(forQuest title: String) -> XCUIElement { app.buttons["CompleteButton_\(title)"]
}
 
    func changeDateButton(forQuest title: String) -> XCUIElement { app.buttons["ChangeDateButton_\(title)"]
}
 
    func abandonButton(forQuest title: String) -> XCUIElement { app.buttons["AbandonButton_\(title)"]
}
 
    func recommitButton(forQuest title: String) -> XCUIElement { app.buttons["RecommitButton_\(title)"]
}
    
    // MARK: - Actions
    @discardableResult
    func tapComplete(forQuest title: String) -> QuestBoardPage {
        completeButton(forQuest: title).tap()
        return self
    }
    
    @discardableResult
    func tapAbandon(forQuest title: String) -> QuestBoardPage {
        abandonButton(forQuest: title).tap()
        return self
    }
    
    @discardableResult
    func tapRecommit(forQuest title: String) -> ChangeDatePage {
        recommitButton(forQuest: title).tap()
        return ChangeDatePage(app:app)
    }
    
    // MARK: - Navigation Actions
    func tapAddQuest() -> AddQuestPage {
        addQuestButton.tap()
        return AddQuestPage(app: app)
    }
    
    func tapChangeDate(forQuest title: String) -> ChangeDatePage {
        changeDateButton(forQuest: title).tap()
        return ChangeDatePage(app: app)
    }
    
    func tapQuestRow(forQuest title: String) -> QuestDetailPage {
        questRow(forQuest: title).tap()
        return QuestDetailPage(app: app)
    }
    
    @discardableResult
    func tapBackToDashboard() -> DashboardPage {
        app.navigationBars.buttons.element(boundBy: 0).tap()
        return DashboardPage(app: app)
    }
}
