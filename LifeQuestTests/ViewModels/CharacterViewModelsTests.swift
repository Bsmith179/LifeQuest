//
//  CharacterViewModelsTests.swift
//  LifeQuestTests
//
//  Created by Icy on 9/15/26.
//

import Testing
@testable import LifeQuest

struct CharacterViewModelsTests {

    @Test("Stats cannot exceed cap of 99", arguments:
    [
        (50,10,60),
        (89,10,99),
        (95,15,99),
        (99,100,99)
    ])
    func testAddStat_RespectsBoundryCap( startStat: Int, amountAdded: Int, expectedResult: Int){
        //Arrange
        let sut = CharacterViewModel()
        sut.character.strength = startStat
        
        //Act
        sut.addStat(category: .strength, amount: amountAdded)
        
        //Assert
        #expect(sut.character.strength == expectedResult)
    }

    @Test("Negative values should be ignored", arguments:
    [
        (10,-5,10),

    ])
    func testAddStat_IgnoresNegativeInputs( startStat: Int, amountAdded: Int, expectedResult: Int){
        //Arrange
        let sut = CharacterViewModel()
        sut.character.strength = startStat
        
        //Act
        sut.addStat(category: .strength, amount: amountAdded)
        
        //Assert
        #expect(sut.character.strength == expectedResult)
    }
    
}
