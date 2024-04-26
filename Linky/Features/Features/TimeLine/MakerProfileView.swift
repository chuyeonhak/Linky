//
//  MakerProfileView.swift
//  Features
//
//  Created by chuchu on 2/16/24.
//

import SwiftUI

import Core

import ConfettiSwiftUI

struct MakerProfileView: View {
    @State private var count: Int = 0
    
    var body: some View {
        VStack(spacing: 20) {
            FidgetTextView("Drag me", fontSize: 32)
                .frame(height: 25)
            
            FidgetTextView("Project Manager @mong._09", fontSize: 25)
                .frame(height: 25)
                .confettiCannon(
                    counter: $count,
                    num: 100,
                    openingAngle: .zero,
                    closingAngle: Angle(degrees: 360),
                    radius: 200)
                .onAppear { count += 1 }
            
            FidgetTextView("UI Designer @hi__luu", fontSize: 25)
                .frame(height: 25)
            
            FidgetTextView("iOS developer @amola_chu", fontSize: 25)
                .frame(height: 25)
            
            FidgetTextView("android developer @ddoeuner", fontSize: 25)
                .frame(height: 25)
            
            FidgetTextView("android developer @u___nan_", fontSize: 25)
                .frame(height: 25)
        }
    }
}
