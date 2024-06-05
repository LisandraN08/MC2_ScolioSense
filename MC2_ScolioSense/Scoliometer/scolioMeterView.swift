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
    var onSave: ((AngleRecord) -> Void)?

    var body: some View {
        ZStack {
            VStack (spacing: 120) {
                HStack {
                    Spacer()
                    button(text: "SUBMIT", width: 146, height: 49, font: 22, bgColor: isPitchPaused ? "BCE0F7" : "BCE0F7", bgTransparency: 1.0, fontColor: "000000", fontTransparency: 0.7, cornerRadius: 20) {
                        saveRecord()

                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showAlert = false
                        }
                    }.rotationEffect(.degrees(-90))
                }.offset(x: 50)
                
                HStack {
                    VStack(spacing:0) {
                        Text("\(motionDetector.slopeDegrees, specifier: "%.f")°")
                            .font(.system(size: 70))
                            .fontWeight(.bold)
                            .foregroundColor(getSeverityColor(for: motionDetector.slopeDegrees))
                            .frame(width:200)
                            .offset(x:30,y:-50)
                        
                        Text(getSeverityText(for: motionDetector.slopeDegrees))
                            .fontWeight(.regular)
                            .foregroundColor(getSeverityColor(for: motionDetector.slopeDegrees))
                            .frame(width:200)
                            .offset(x:30,y:-50)

                    }
                    .rotationEffect(.degrees(-90))

                    
                    Spacer()
                    ZStack {
                        HStack {
                            Spacer()
                            ZStack {
                                Ellipse()
                                    .frame(width: 134, height: 200)
                                    .foregroundColor(Color(hex: "BCE0F7", transparency: 0.2))
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
//                    button(text: "XSUBMIT", width: 146, height: 49, font: 22, bgColor: "BCE0F7", bgTransparency: 1.0, fontColor: "000000", fontTransparency: 0.7, cornerRadius: 20) {
//                        showAlert = true
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                            showAlert = false
//                        }
//                    }

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

            if showAlert {
                HStack {
                    CustomAlert(title: "Angle Saved", message: "", buttonText: "") {
                        showAlert = false
                    }
                    .rotationEffect(.degrees(-90))
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showAlert)
            }
        }
        .onAppear {
            motionDetector.startDeviceMotionUpdates()
        }
    }

    private func saveRecord() {
        let newRecord = AngleRecord(angle: motionDetector.slopeDegrees, date: Date())
        RecordManager.shared.saveRecord(newRecord)
        onSave?(newRecord)
    }
    
    private func calculateOffset() -> CGFloat {
        let baseOffset: CGFloat = 30
        let maxOffset: CGFloat = 280
        let offset = CGFloat(motionDetector.slopeDegrees) * maxOffset / 90.0
        return offset
    }
    
    private func getSeverityColor(for degrees: Double) -> Color {
        let absDegrees = abs(degrees)
                switch absDegrees {
                case 0..<10:
                    return .green
                case 10..<20:
                    return .yellow
                case 20..<40:
                    return .orange
                default:
                    return .red
                }
        }
    
    private func getSeverityText(for degrees: Double) -> String {
        let absDegrees = abs(degrees)
            if absDegrees < 10 {
                return "Normal"
            } else if absDegrees < 20 {
                return "Mild"
            } else if absDegrees < 40 {
                return "Moderate"
            } else {
                return "Severe"
            }
        }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    scolioMeterView()
}


