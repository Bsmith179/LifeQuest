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
        }
        .onChange(of: scenePhase) { oldPhase, newPhase in
            switch newPhase {
            case .active:
                let drain = questVM.evaluateTimePassage()
                characterVM.applyDrain(XPAmount: drain)
                break
                
            case .background:
                characterVM.saveData()
                questVM.saveData()
                shopVM.saveData()
                break
            case .inactive:
                break
            @unknown default:
                break
                
            }
        }
    }
}
