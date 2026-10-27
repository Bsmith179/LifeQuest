//
//  ChangeDateButton.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct ChangeDateButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Label("Change Date", systemImage: "calendar.badge.clock")
        }
        .buttonStyle(.bordered)
        .tint(.blue)
    }
}
 
#Preview("Change Date Button") {
    ChangeDateButton(action: {})
        .padding()
}
