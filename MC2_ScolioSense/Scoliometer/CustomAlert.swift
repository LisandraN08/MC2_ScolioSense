//
//  CustomAlert.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 01/06/24.
//

import SwiftUI

struct CustomAlert: View {
    var title: String
    var message: String
    var buttonText: String
    var buttonAction: () -> Void
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        ZStack {
            
            VStack(spacing: 20) {
                Text(title)
                    .font(.title)
                    .bold()
                Text(message)
                    .font(.body)
                    .multilineTextAlignment(.center)
                Button(action: {
                    buttonAction()
                }) {
                    Text(buttonText)
                        .font(.headline)
                        .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .dark ? Color.white : Color.black)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
            }
            .frame(width: 300)
            .padding()
            .background(Color(hex: "BCE0F7", transparency: 0.8))
            .cornerRadius(20)
        }
    }
}
    
struct CustomAlert_Previews: PreviewProvider {
    static var previews: some View {
        CustomAlert(title: "Sample Title", message: "Sample Message", buttonText: "OK") {}
    }
}
