//
//  MakerProfileView.swift
//  Features
//
//  Created by chuchu on 2/16/24.
//

import SwiftUI

import Core

import ConfettiSwiftUI
import MarqueeText

struct MakerProfileView: View {
    @State private var count: Int = 0
    
    var body: some View {
        ZStack {
            VStack {
                let text = String(
                    repeating: UserDefaultsManager.shared.notice + "    ",
                    count: 5
                )
                
                MarqueeText(
                    text: text,
                    font: FontManager.shared.pretendard(weight: .semiBold, size: 32),
                    leftFade: 16,
                    rightFade: 16,
                    startDelay: 0
                )
                .makeCompact()
                .foregroundColor(Color(UIColor.code3 ?? .white))
                .padding([.top, .horizontal], 32)
                
                Spacer()
            }
            
            VStack {
                FidgetTextView("Project Manager @mong._09", fontSize: 25)
                    .frame(height: 25)
                    .confettiCannon(
                        counter: $count,
                        num: 100,
                        openingAngle: .zero,
                        closingAngle: Angle(degrees: 360),
                        radius: 200)
                    .onAppear { count += 1 }
                Spacer()
                FidgetTextView("UI Designer @hi__luu", fontSize: 25)
                    .frame(height: 25)
                Spacer()
                FidgetTextView("iOS developer @amola_chu", fontSize: 25)
                    .frame(height: 25)
                Spacer()
                FidgetTextView("android developer @min._.dda", fontSize: 25)
                    .frame(height: 25)
            }
            .padding(.top, 32)
            .frame(height: 160)
        }
    }
}
