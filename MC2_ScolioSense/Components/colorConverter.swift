//
//  colorConverter.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 01/06/24.
//

import SwiftUI

extension Color {
    init(hex: String, transparency: Double) {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexString = hexString.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        if Scanner(string: hexString).scanHexInt64(&rgb) {
            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0

            self.init(red: red, green: green, blue: blue, opacity: transparency)
        } else {
            self.init(red: 0, green: 0, blue: 0)
        }
    }
}
