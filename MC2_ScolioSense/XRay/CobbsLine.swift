//
//  CobbsLine.swift
//  MC2_ScolioSense
//
//  Created by Jonathan Zeann Philibert Samuel on 03/06/24.
//

import Foundation
import SwiftUI

struct CobbsLine: View {
    @State var line1StartPoint: CGPoint = CGPoint(x: 300, y: 100)
    @State var line1EndPoint: CGPoint = CGPoint(x: 100, y: 100)
    @State var line2StartPoint: CGPoint = CGPoint(x: 300, y: 300)
    @State var line2EndPoint: CGPoint = CGPoint(x: 100, y: 300)
    @Binding var y: Double
    @State var cobbAngle: CGFloat = 0.0
    @State var cobbSeverity: String = ""
    
    var onSave: ((AngleRecord) -> Void)?
    @State private var showAlert = false

    
    var body: some View {
        ZStack {
            if showAlert {
                HStack {
                    CustomAlert(title: "Angle Saved", message: "", buttonText: "") {
                        showAlert = false
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showAlert)
            }
            VStack {
                Spacer()
                ZStack {
                    // Line 1
                    Path { path in
                        path.move(to: line1StartPoint)
                        path.addLine(to: line1EndPoint)
                    }
                    .strokedPath(StrokeStyle(lineWidth: 4, lineCap: .square, lineJoin: .round))
                    .foregroundColor(.black)
                    
                    // Line 2
                    Path { path in
                        path.move(to: line2StartPoint)
                        path.addLine(to: line2EndPoint)
                    }
                    .strokedPath(StrokeStyle(lineWidth: 4, lineCap: .square, lineJoin: .round))
                    .foregroundColor(.black)
                    
                    // Circle for Line 1 Start Point
                    Circle()
                        .frame(width: 30, height: 30)
                        .opacity(0.4)
                        .position(line1StartPoint)
                        .foregroundColor(.red)
                        .gesture(DragGesture()
                            .onChanged { value in
                                line1StartPoint = value.location
                                y = value.location.y
                                updateCobbValues()
                            })
                    
                    // Circle for Line 1 End Point
                    Circle()
                        .frame(width: 30, height: 30)
                        .opacity(0.4)
                        .position(line1EndPoint)
                        .foregroundColor(.red)
                        .gesture(DragGesture()
                            .onChanged { value in
                                line1EndPoint = value.location
                                y = value.location.y
                                updateCobbValues()
                            })
                    
                    // Circle for Line 2 Start Point
                    Circle()
                        .frame(width: 30, height: 30)
                        .opacity(0.4)
                        .position(line2StartPoint)
                        .foregroundColor(.red)
                        .gesture(DragGesture()
                            .onChanged { value in
                                line2StartPoint = value.location
                                y = value.location.y
                                updateCobbValues()
                            })
                    
                    // Circle for Line 2 End Point
                    Circle()
                        .frame(width: 30, height: 30)
                        .opacity(0.4)
                        .position(line2EndPoint)
                        .foregroundColor(.red)
                        .gesture(DragGesture()
                            .onChanged { value in
                                line2EndPoint = value.location
                                y = value.location.y
                                updateCobbValues()
                            })
                }
                
                
                HStack {
                    button(text:"SUBMIT", width: 85, height:49, font: 15, bgColor: "BCE0F7", bgTransparency: 0.5 , fontColor:"000000", fontTransparency: 0.7, cornerRadius: 20){
                        submitData()
                        showAlert = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            showAlert = false
                        }
                    }
                    VStack(alignment: .leading) {
                        // Display Cobb's Angle
                        Text(String(format: "Cobb's Angle: %.2f°", cobbAngle))
                            .foregroundColor(.blue)
                            .frame(alignment: .leading)
                        
                        // Display Cobb's Angle Severity
                        Text(String(format: "Severity: \(cobbSeverity)"))
                            .foregroundColor(severityColor())
                            .frame(alignment: .leading)
                    }
                }
            }
        }
    }
    
    func calculateCobbAngle() -> CGFloat {
        let angle1 = atan2(line1EndPoint.y - line1StartPoint.y, line1EndPoint.x - line1StartPoint.x)
        let angle2 = atan2(line2EndPoint.y - line2StartPoint.y, line2EndPoint.x - line2StartPoint.x)
        var angleDifference = abs(angle1 - angle2) * 180 / .pi
        
        
        if angleDifference > 180 {
            angleDifference = 360 - angleDifference
        }
        return angleDifference
    }
    
    func determineAngle () -> String {
        let severityLevel = calculateCobbAngle()
        
        if severityLevel > 40 {
            return "Severe"
        } else if severityLevel > 20 {
            return "Moderate"
        } else if severityLevel > 10 {
            return "Mild"
        } else {
            return "Normal"
        }
    }
    
    func severityColor() -> Color {
            switch cobbSeverity {
            case "Severe":
                return .red
            case "Moderate":
                return .orange
            case "Mild":
                return .yellow
            case "Normal":
                return .green
            default:
                return .blue
            }
        }
    
    func updateCobbValues() {
        cobbAngle = calculateCobbAngle()
        cobbSeverity = determineAngle()
    }
    
    func submitData() {
        let newRecord = AngleRecord(angle: Double(cobbAngle), date: Date())
        RecordManager.shared.saveRecord(newRecord)
    }
    
}

struct Trial_Previews: PreviewProvider {
    static var previews: some View {
        CobbsLine(y: .constant(0.0))
    }
}
