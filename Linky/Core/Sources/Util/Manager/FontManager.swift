//
//  FontManager.swift
//  CoreInterface
//
//  Created by chuchu on 2023/04/26.
//

import UIKit

public struct FontManager {
    public static let shared = FontManager()
    
    public func pretendard(weight: Weight, size: CGFloat) -> UIFont {
        let name = "Pretendard-" + weight.name
        return UIFont(name: name, size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    public enum Weight {
        case black
        case bold
        case extraBold
        case extraLight
        case light
        case medium
        case regular
        case semiBold
        case thin
        
        var name: String {
            switch self {
            case .black: return "Black"
            case .bold: return "Bold"
            case .extraBold: return "ExtraBold"
            case .extraLight: return "ExtraLight"
            case .light: return "Light"
            case .medium: return "Medium"
            case .regular: return "Regular"
            case .semiBold: return "SemiBold"
            case .thin: return "Thin"
            }
        }
    }
}

