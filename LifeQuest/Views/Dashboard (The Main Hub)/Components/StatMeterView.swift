//
//  StatMeterView.swift
//  LifeQuest
//
//  Created by Icy on 10/27/26.
//

import SwiftUI
 
struct StatMeterView: View {
    let title: String
    let current: Int
    let max: Int
    let color: Color
    
    var progress: Double {
        guard max > 0 else { return 0 }
        let clampedCurrent = min(current, max)
        return Double(clampedCurrent) / Double(max)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            HStack{
                Text(title)
                    .font(.headline)
                Spacer()
                Text("\(current) / \(max)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading){
                    Rectangle()
                        .frame(width: geometry.size.width, height: 12)
                        .opacity(0.3)
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(width: min(CGFloat(self.progress) * geometry.size.width, geometry.size.width),height: 12)
                        .foregroundColor(self.color)
                        .animation(.linear, value: current)
                    
                }
                .cornerRadius(6)
            }
            .frame(height: 12)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("\(title)Meter")
    }
}
 
#Preview("Stat Meter Variations"){
    VStack(spacing: 20){
        StatMeterView(title: "XP", current: 50, max: 100, color: .green)
        StatMeterView(title: "Strength", current: 1, max: 99, color: .red)
        StatMeterView(title: "Focus", current: 99, max: 99, color: .blue)
        StatMeterView(title: "Charisma", current: 85, max: 99, color: .orange)
    }
    .padding()
}

