//
//  CircularProgressView.swift
//  Features
//
//  Created by chuchu on 4/2/24.
//

import SwiftUI

public struct CircularProgressView: View {
    let style: Style
    @Binding var percentage: CGFloat
    
    public init(style: Style, percentage: Binding<CGFloat>) {
        self.style = style
        self._percentage = percentage
    }
    
    public var body: some View {
        ZStack {
            Circle()
                .stroke(
                    style.backgroundColor,
                    lineWidth: style.stoke.lineWidth
                )
            
            Circle()
                .trim(from: 0, to: percentage)
                .stroke(
                    style.progressColor,
                    style: StrokeStyle(
                        lineWidth: style.stoke.lineWidth,
                        lineCap: .round)
                )
        }
        .padding(style.stoke.lineWidth / 2) // stoke 때문에 패딩 필요.
        .rotationEffect(style.startPosition.angle)
        .onAppear(perform: onAppearAction)
        .animation(.spring, value: percentage)
    }
    
    private func onAppearAction() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            percentage = style.percentage
        }
    }
}

extension CircularProgressView {
    public struct Style {
        public static let `default` = CircularProgressView.Style(
            startPosition: .top,
            backgroundColor: .gray.opacity(0.2),
            progressColor: Color(UIColor.main ?? .clear),
            stoke: StrokeStyle(lineWidth: 7, lineCap: .round),
            percentage: 0.5
        )
        
        /// StartPostion, default is top.
        var startPosition: Position = Style.default.startPosition
        
        /// progressBar background Color. Default is gray.
        var backgroundColor: Color = Style.default.backgroundColor
        
        /// progressBar full Color. Default is yellow.
        var progressColor: Color = Style.default.progressColor
        
        /// stokeStyle
        var stoke: StrokeStyle = Style.default.stoke
        
        /// Percentage (0.0~1.0), default is 1.
        var percentage: CGFloat = Style.default.percentage
        
        enum Position {
            case top, left, right, bottom
            
            var angle: Angle {
                switch self {
                case .top: Angle.radians(-.pi / 2)
                case .left: Angle.radians(0)
                case .right: Angle.radians(.pi)
                case .bottom: Angle.radians(.pi / 2)
                }
            }
        }
    }
}
