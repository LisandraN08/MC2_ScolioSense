//
//  scolioMeterView.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 01/06/24.
//
import SwiftUI

struct scolioMeterView: View {
    @StateObject private var motionDetector = MotionManager()
    @State private var isPitchPaused = false
    @State private var showAlert = false


    var body: some View {
        ZStack {
            VStack (spacing: 120) {
                HStack {
                    Spacer()
                    button(text: isPitchPaused ? "START" : "HOLD", width: 146, height: 49, font: 22, bgColor: isPitchPaused ? "CAE5CA" : "fdc9c9", bgTransparency: 1.0, fontColor: "000000", fontTransparency: 0.7, cornerRadius: 20) {
                        isPitchPaused.toggle()
                        motionDetector.isPaused = isPitchPaused
                    }.rotationEffect(.degrees(-90))
                }.offset(x: 50)
                
                HStack {
                    VStack {
                        Text("\(motionDetector.slopeDegrees, specifier: "%.f")°")
                            .rotationEffect(.degrees(-90))
                            .font(.system(size: 70))
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Ellipse()
                                    .frame(width: 134, height: 200)
                                    .foregroundColor(Color(hex: "BCE0F7", transparency: 0.9))
                                HStack(spacing: -40) {
                                    Text("Place spine")
                                        .rotationEffect(.degrees(-90))
                                    Text("here")
                                        .rotationEffect(.degrees(-90))
                                }.offset(x: -25)
                            }.offset(x: 80)
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    button(text: "SUBMIT", width: 146, height: 49, font: 22, bgColor: "BCE0F7", bgTransparency: 1.0, fontColor: "000000", fontTransparency: 0.7, cornerRadius: 20)
                    {
                        showAlert = true
                    }
                        .rotationEffect(.degrees(-90))
                        .offset(x: 50)
                        .opacity(isPitchPaused ? 1.0:0.0)
                  
                }
            }
            .padding(30)
            
            ZStack {
                Image("rectangle")
                    .resizable()
                    .frame(width: 146, height: 650)
                    .offset(x:-5)
                Image("elipse")
                    .offset(y: calculateOffset())
                    .animation(.easeInOut(duration: 0.5), value: motionDetector.slopeDegrees)
            }
            
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .rotationEffect(.degrees(-90))
                    Spacer()
                }.padding(.leading, 20)
            }.padding()
            if showAlert {
                CustomAlert(title: "Data Saved", message: "Your data has been stored", buttonText: "OK") {
                    showAlert = false
                }.rotationEffect(.degrees(-90))

                
            }
        }

        .onAppear {
            motionDetector.startDeviceMotionUpdates()
        }
    }
    private func calculateOffset() -> CGFloat {
        let baseOffset: CGFloat = 30

            let maxOffset: CGFloat = 280
            let offset = CGFloat(motionDetector.slopeDegrees) * maxOffset / 90.0
            return offset
        }

}


#Preview {
    scolioMeterView()
}

