//
//  CharacterViewModelsTests.swift
//  LifeQuestTests
//
//  Created by Icy on 9/15/26.
//

import Testing
@testable import LifeQuest

struct CharacterViewModelsTests {

    //MARK: - Add Stats
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
    
    @Test("Adding to strength must leave other categories unchanged", arguments:
    [
        (50,10,60),

    ])
    func testAddStat_ModifiesOnlyTargetCategory( startStat: Int, amountAdded: Int, expectedResult: Int){
        //Arrange
        let sut = CharacterViewModel()
        sut.character.strength = startStat
        
        //Act
        sut.addStat(category: .strength, amount: amountAdded)
        
        //Assert
        #expect(sut.character.intelligence == 0)
        #expect(sut.character.charisma == 0)
        #expect(sut.character.focus == 0)
    }
    
    //MARK: - Deduct Stats
    @Test("Missing quest cannot cause stat to drop to negative numbers", arguments:
    [
        (10,5,5),
        (5,5,0),
        (3,5,0)
    ])
    func testDeductStat_RespectsZeroFloor(currentStat: Int, amountToDeduct: Int, expectedResult: Int){
        
        //Arrange
        let sut = CharacterViewModel()
        sut.character.strength = currentStat
        
        //Act
        sut.deductStat(category: .strength, amount: amountToDeduct)
        
        //Assert
        #expect(sut.character.strength == expectedResult)
    }
    
    @Test("Must reject negative input", arguments:
    [
        (10,-5,10),

    ])
    func testDeductStat_IgnoresNegativeInputs(currentStat: Int, amountToDeduct: Int, expectedResult: Int){
        let sut = CharacterViewModel()
        sut.character.strength = currentStat
        
        sut.deductStat(category: .strength, amount: amountToDeduct)
        
        #expect(sut.character.strength == expectedResult)
    }
    
    //MARK: - GainXP
    @Test("XP threshold is 1000, excess XP must carry over", arguments:
    [
        (0,500,1,500),
        (500,500,2,0),
        (800,500,2,300),
        (100,2400,3,500)
    ])
    func testGainXP_TriggersLevelUpAndRollover(currentXP: Int, xpToAdd: Int, expectedLevel: Int, expectedXP: Int){
        let sut = CharacterViewModel()
        sut.character.currentXP = currentXP
        
        sut.gainXP(amount: xpToAdd)
        
        #expect(sut.character.level == expectedLevel)
        #expect(sut.character.currentXP == expectedXP)
        
    }
    
    @Test("Earning negative XP should not cause a level up or XP change", arguments:
    [
        (500,-100,1,500)
 
    ])
    func testGainXP_IgnoresNegativeInputs(currentXP: Int, xpToAdd: Int, expectedLevel: Int, expectedXP: Int){
        let sut = CharacterViewModel()
        sut.character.currentXP = currentXP
        
        sut.gainXP(amount: xpToAdd)
        
        #expect(sut.character.level == expectedLevel)
        #expect(sut.character.currentXP == expectedXP)
        
    }
    
    //MARK: - Add Gold
    @Test("Adding gold cannot exceed cap", arguments:
    [
        (100,50,150),
        (99000,999,9999),
        (99000,5000,9999)
    ])
    func testAddGold_RespectsCap(currentGold: Int, goldToAdd: Int, expectedResult: Int){
        let sut = CharacterViewModel()
        sut.character.gold = currentGold
        
        sut.addGold(amount: goldToAdd)
        
        #expect(sut.character.gold == expectedResult)
    }
}
