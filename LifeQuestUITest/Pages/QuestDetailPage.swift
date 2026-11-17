//
//  QuestDetailPage.swift
//  LifeQuest
//
//  Created by Icy on 11/17/26.
//

import XCTest
 
 
 
 
struct QuestDetailPage {
 
    let app: XCUIApplication
 
    
 
    //MARK: - Locators
 
    var closeButton: XCUIElement {
 
        app.buttons["CloseQuestDetailButton"]
 
    }
 
    
 
    //MARK: - Actions
 
    @discardableResult
 
    func tapClose() -> QuestBoardPage {
 
        closeButton.tap()
 
        return QuestBoardPage(app: app)
 
    }
 
}
