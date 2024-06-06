//
//  textHeading.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 01/06/24.
//

import SwiftUI

struct textHeading: View {
    let text: String
        
        init(text: String) {
            self.text = text
        }
    
    var body: some View {
        Text(text)
                 .font(.custom("SFCompactRounded-Bold", size: 40))
                 .bold()
                 .fontWeight(.black)
                 .foregroundColor(Color(hex:"000000", transparency: 0.9))
                 .lineSpacing(20)}
}

#Preview {
    textHeading(text: "balba")
}
