//
//  HexColor.swift
//  diya-tila-ios
//
//  Created by Rodion Malakhov on 06.04.2023.
//

import SwiftUI

extension Color {
    static let primaryColor: Color = Color(hex: 0x4B94F5)
    static let secondaryColor: Color = Color(hex: 0x000000)
    
    init(hex: UInt, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xff) / 255.0
        let green = Double((hex >> 8) & 0xff) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
