//
//  ChangeDateButton.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct ChangeDateButton: View {
    let questTitle: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label("Change Date", systemImage: "calendar.badge.clock")
        }
        .buttonStyle(.bordered)
        .tint(.blue)
        .accessibilityIdentifier("ChangeDateButton_\(questTitle)")
    }
}
 
#Preview("Change Date Button") {
    ChangeDateButton(questTitle: "Test", action: {})
        .padding()
}
