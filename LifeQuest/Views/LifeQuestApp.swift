//
//  LifeQuestApp.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
@main
struct LifeQuestApp: App {
    @StateObject private var characterVM = CharacterViewModel()
    @StateObject private var questVM = QuestViewModel()
    @StateObject private var shopVM = ShopViewModel()
    
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            DashboardView()
                .environmentObject(characterVM)
                .environmentObject(questVM)
                .environmentObject(shopVM)
                .onAppear {
                    // 1. Wipe data for a clean testing slate
                    if CommandLine.arguments.contains("-UITest_DefaultState") ||
                       CommandLine.arguments.contains("-UITest_MockActiveQuest") {
                        
                        questVM.activeQuests.removeAll()
                        shopVM.availableRewards.removeAll()
                        
                        characterVM.character.gold = 0
                        characterVM.character.currentXP = 0
                        characterVM.character.level = 1
                    }
                    
                    // 2. Inject specific mock data for the Quest Board UI Tests
                    if CommandLine.arguments.contains("-UITest_MockActiveQuest") {
                        questVM.createNewQuest(
                            title: "Test Quest",
                            categories: [.strength],
                            difficulty: 1.0,
                            frequency: .daily,
                            startDate: Date(),
                            endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())
                        )
                    }
                }
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            // Protect real save files from being overwritten by robotic test data
            let isUITesting = CommandLine.arguments.contains("-UITest_DefaultState") ||
                              CommandLine.arguments.contains("-UITest_MockActiveQuest")
            
            switch newPhase {
            case .active:
                if !isUITesting {
                    let drain = questVM.evaluateTimePassage()
                    characterVM.applyDrain(XPAmount: drain)
                }
            case .background:
                if !isUITesting {
                    characterVM.saveData()
                    questVM.saveData()
                    shopVM.saveData()
                }
            case .inactive:
                break
            @unknown default:
                break
            }
        }
    }
}
