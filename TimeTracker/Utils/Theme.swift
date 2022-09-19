//
//  Theme.swift
//  TimeTracker
//
//  Created by Yunus Yunusov on 19.09.2022.
//

import UIKit

public enum Theme {
    public static func dynamicColor(light: Int, dark: Int) -> UIColor{
        .init { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return uiColor(rgb: light)
            default:
                return uiColor(rgb: dark)
            }
        }
    }

    public static func uiColor(rgb: Int) -> UIColor {
        .init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0xFF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0xFF) / 255.0,
            alpha: 1
        )
    }
}

// MARK: - Colors
extension Theme {

    public static var backgroundColor: UIColor {
        dynamicColor(light: 0xF9F9FF, dark: 0x18152C)
    }

    public static var cellBackgroundColor: UIColor {
        dynamicColor(light: 0xFFFFFF, dark: 0x292639)
    }

    public static var labelColor: UIColor {
        dynamicColor(light: 0x000000, dark: 0xFFFFFF)
    }
}
