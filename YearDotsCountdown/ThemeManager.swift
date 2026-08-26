//
//  ThemeManager.swift
//  YearDotsCountdown
//
//  Created by Jónatas Silva on 26/08/26.
//

import SwiftUI
import UIKit

enum AppTheme: String, CaseIterable, Identifiable {
    case system = "system"
    case light = "light"
    case dark = "dark"
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .system: return "Automatic"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

enum ThemeManager {
    static func applyTheme(_ theme: String) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        
        let style: UIUserInterfaceStyle
        switch theme {
        case "light":
            style = .light
        case "dark":
            style = .dark
        default:
            style = .unspecified // This follows the system theme
        }
        
        for window in windowScene.windows {
            window.overrideUserInterfaceStyle = style
        }
    }
}
