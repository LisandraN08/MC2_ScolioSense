//
//  CobbsLine.swift
//  MC2_ScolioSense
//
//  Created by Jonathan Zeann Philibert Samuel on 03/06/24.
//

import Foundation
import SwiftUI

struct CobbsLine: View {
    @State var line1StartPoint: CGPoint = CGPoint(x: 300, y: 200)
    @State var line1EndPoint: CGPoint = CGPoint(x: 100, y: 200)
    @State var line2StartPoint: CGPoint = CGPoint(x: 300, y: 400)
    @State var line2EndPoint: CGPoint = CGPoint(x: 100, y: 400)
    @Binding var y: Double
    @State var cobbAngle: CGFloat = 0.0

    var body: some View {
        VStack {
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
                            cobbAngle = calculateCobbAngle()
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
                            cobbAngle = calculateCobbAngle()
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
                            cobbAngle = calculateCobbAngle()
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
                            cobbAngle = calculateCobbAngle()
                        })
        }
            VStack {
                // Display Cobb's Angle
                Text(String(format: "Cobb's Angle: %.2f°", cobbAngle))
                    .foregroundColor(.blue)
            }
                .frame(width: 200, height: 100)
                .position(x: 200, y:300)
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
}

struct Trial_Previews: PreviewProvider {
    static var previews: some View {
        CobbsLine(y: .constant(0.0))
    }
}
