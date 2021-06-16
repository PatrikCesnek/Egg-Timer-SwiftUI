//
//  HardnessProgressView.swift
//  EggTimer-SwiftUI
//
//  Created by Patrik Cesnek on 16/01/2021.
//

import SwiftUI

struct HardnessProgressViewStyle: ProgressViewStyle {
    var progressColour: Color = .yellow
        var successColour: Color = .orange
        var progress: CGFloat
        var total: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        ProgressView(configuration)
            .padding()
            .foregroundColor(progress >= total ? successColour : progressColour)
            .accentColor(progress >= total ? successColour : progressColour)
            .animation(.linear(duration: 0.1))
    }
}
