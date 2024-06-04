//
//  mainView.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 03/06/24.
//

import SwiftUI

struct mainView: View {
    @State private var records: [AngleRecord] = []
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Text("Hello, friends!")
                            .font(.system(size: 30, weight: .bold, design: .rounded))
                        Spacer()
                    }.padding(.bottom,30)
                    
                    VStack(spacing:20) {
                        
                        Button(action: {
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color(hex: "81C9F3", transparency: 0.5))
                                    .frame(width: 348, height: 119)
                                HStack(spacing:20) {
                                    HStack {
                                        Image("bodyscan")
                                            .resizable()                .frame(width: 51, height: 60)
                                            .offset(x:-10)
                                    }
                                    
                                    
                                    VStack(spacing:5) {
                                        
                                        HStack(spacing:5) {
                                            //Scan your Back
                                            Text("Scan your Back").font(.system(size: 22, weight: .medium, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .padding(.top,5)                  .foregroundColor(.black.opacity(0.7))
                                            
                                        }.padding(.leading,5)
                                        
                                        //Analyze your spine posture
                                        Text("Analyze your spine posture").font(.system(size: 13, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                        
                                    }
                                }
                                
                            }
                        }
                        // scoliometer
                        NavigationLink(destination: scolioMeterView(onSave: { newRecord in
                            records.append(newRecord)
                        })) {                        ZStack {
                            RoundedRectangle(cornerRadius: 22)
                                .fill(Color(hex: "81C9F3", transparency: 0.5))
                                .frame(width: 348, height: 119)
                            HStack(spacing:30) {
                                Image(systemName: "ruler")
                                    .resizable()             .frame(width: 66, height: 31)
                                    .foregroundColor(Color(hex: "000000", transparency: 0.8))
                                
                                
                                VStack(spacing:5) {
                                    
                                    HStack(spacing:5) {
                                        //Scan your Back
                                        Text("Scoliometer").font(.system(size: 22, weight: .medium, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                        
                                        Image(systemName: "chevron.right")
                                            .resizable()
                                            .frame(width: 8, height: 8)
                                            .padding(.top,5)                  .foregroundColor(.black.opacity(0.7))
                                        
                                    }.padding(.leading,-60)
                                    
                                    //Analyze your spine posture
                                    Text("Measure the curve of your spine").font(.system(size: 13, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                    
                                }
                            }
                            
                        }
                            
                        }
                        //xray
                        Button(action: {
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color(hex: "81C9F3", transparency: 0.5))
                                    .frame(width: 348, height: 119)
                                HStack(spacing:0) {
                                    Image("xray")
                                        .resizable()                .frame(width: 43, height: 44)
                                        .offset(x:45)
                                    
                                    
                                    VStack(spacing:5) {
                                        
                                        HStack(spacing:15) {
                                            //Scan your Back
                                            Text("X-ray Scan").font(.system(size: 22, weight: .medium, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .padding(.top,5)                  .foregroundColor(.black.opacity(0.7))
                                            
                                        }.padding(.leading,5)
                                        
                                        //Analyze your spine posture
                                        
                                        Text("Measure the anteroposterior X-rays").font(.system(size: 13, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                            .padding(.leading,80)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        HStack {
                            Text("Your latest record")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Spacer()
                        }.padding(.top,20)
                        
                        ForEach(records.reversed(), id: \.id) { record in
                            VStack(alignment: .leading) {
                                Text("Angle: \(record.angle, specifier: "%.2f")°")
                                Text("Date: \(record.date, formatter: dateFormatter)")
                            }
                            .padding()
                            .background(Color(hex: "ffffff", transparency: 0.5))
                            .cornerRadius(8)
                            .gesture(
                                DragGesture()
                                    .onEnded { value in
                                        if value.translation.width < -100 {
                                            deleteRecord(record)
                                        }
                                    }
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }

                        

                    }
                    Spacer()
                }.padding()
                    .onAppear {
                        records = RecordManager.shared.fetchRecords()
                    }
            }
        }
        
    }
    private func deleteRecord(_ record: AngleRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records.remove(at: index)
            // Update your storage (e.g., UserDefaults) or database here
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
    mainView()
}
