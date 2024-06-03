//
//  button.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 01/06/24.
//

import SwiftUI

struct button: View {
        let text: String
        let font: Int
        let width: Int
        let height: Int
        let bgColor: String
        let bgTransparency: Double
        let fontColor: String
        let fontTransparency: Double
        let cornerRadius: CGFloat
        let action: (() -> Void)?

        init(text: String, width: Int, height: Int, font: Int, bgColor: String, bgTransparency: Double, fontColor: String, fontTransparency: Double, cornerRadius: CGFloat, action: (() -> Void)? = nil) {
            self.text = text
            self.width = width
            self.height = height
            self.font = font
            self.bgColor = bgColor
            self.bgTransparency = bgTransparency
            self.fontColor = fontColor
            self.fontTransparency = fontTransparency
            self.cornerRadius = cornerRadius
            self.action = action
        }
    var body: some View {
        Button(action: {
                    action?()
                }) {
                    HStack(spacing: 4) {
                        Spacer()
                        Text(text)
                            .font(.system(size: CGFloat(font), weight: .bold))
                            .foregroundColor(Color(hex: fontColor, transparency: fontTransparency))
    
                        Spacer()
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: CGFloat(width), height: CGFloat(height))
                .background(Color(hex: bgColor, transparency: bgTransparency))
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))    }
}

#Preview {
    button(text:"HOLD", width: 146, height:49, font: 22, bgColor: "FF0000", bgTransparency: 0.2 , fontColor:"000000", fontTransparency: 0.7, cornerRadius: 20)
}
