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
                    }.padding(.bottom,30).padding(.leading,20)
                    
                    VStack(spacing:20) {
                        
                        NavigationLink(destination: ScanBodyPoseView(onSave: { newRecord in
                            records.append(newRecord)})) {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(Color(hex: "81C9F3", transparency: 0.5))
                                        .frame(width: 348, height: 119)
                                    HStack(spacing:20) {
                                        HStack {
                                            Image("bodyscan")
                                                .resizable().frame(width: 60, height: 60)
                                                .offset(x:-15)
                                        }
                                        
                                        
                                        VStack(spacing:5) {
                                            
                                            HStack(spacing:5) {
                                                //Scan your Back
                                                Text("Scan your Body").font(.system(size: 22, weight: .medium, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                                
                                                Image(systemName: "chevron.right")
                                                    .resizable()
                                                    .frame(width: 8, height: 8)
                                                    .padding(.top,5)                  .foregroundColor(.black.opacity(0.7))
                                                
                                            }.padding(.leading,5)
                                            
                                            //Analyze your spine posture
                                            Text("Analyze your spine posture").font(.system(size: 13, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                            
                                        }.offset(x:-2)
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
                                    .offset(x:5)
                                
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
                                    
                                }.padding(.leading,10)
                            }
                            
                        }
                            
                        }
                        
                        //xray
                        NavigationLink(destination: XRayScoliosis()) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color(hex: "81C9F3", transparency: 0.5))
                                    .frame(width: 348, height: 119)
                                HStack(spacing:0) {
                                    Image("xray")
                                        .resizable().frame(width: 43, height: 44)
                                        .offset(x:13)
                                    
                                    
                                    VStack(spacing:5) {
                                        
                                        HStack() {
                                            //Scan your Back
                                            Text("X-ray Scan").font(.system(size: 22, weight: .medium, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                            
                                            Image(systemName: "chevron.right")
                                                .resizable()
                                                .frame(width: 8, height: 8)
                                                .padding(.top,5)                  .foregroundColor(.black.opacity(0.7))
                                                .padding(.leading).offset(x:-5)
                                        }.offset(x:5)
                                        
                                        //Analyze your spine posture
                                        VStack(alignment: .leading) {
                                            Text("Measure the anteroposterior").font(.system(size: 13, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                                .padding(.leading,80)
                                            Text("X-rays").font(.system(size: 13, weight: .regular, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                                .padding(.leading,80)
                                            
                                        }.offset(x:-20)
                                        
                                    }
                                }
                                
                            }
                            
                        }
                        HStack {
                            Text("Your latest record")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.leading)
                        
                        VStack {
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color(hex: "81C9F3", transparency: 1.0), lineWidth: 1)
                                    .frame(width: 345)
                                    .padding()
                                
                                VStack(alignment: .leading) {
                                    ForEach(records.reversed(), id: \.id) { record in
                                        VStack(alignment: .leading) {
                                            HStack(spacing: 20) {
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 7) {
                                                        Text("\(record.date, formatter: dateFormatter)")
                                                        Text("\(record.angle, specifier: "%.2f")°")
                                                            .font(.system(size: 22))
                                                            .fontWeight(.bold)
                                                    }
                                                    Spacer()
                                                }
                                                Spacer()
                                                let recordAbs = abs(record.angle)
                                                if recordAbs <= 10 {
                                                    ZStack {
                                                        Text("Normal").opacity(0.7)
                                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                                            .fill(Color.green)
                                                            .opacity(0.3)
                                                            .frame(width: 100, height: 30)
                                                    }
                                                    
                                                } else if recordAbs < 20 {
                                                    ZStack {
                                                        Text("Mild").opacity(0.7)
                                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                                            .fill(Color.yellow)
                                                            .opacity(0.3)
                                                            .frame(width: 100, height: 30)
                                                    }
                                                } else if recordAbs < 40 {
                                                    ZStack {
                                                        Text("Moderate").opacity(0.7)
                                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                                            .fill(Color.orange)
                                                            .opacity(0.3)
                                                            .frame(width: 100, height: 30)
                                                    }
                                                } else {
                                                    ZStack {
                                                        Text("Severe").opacity(0.7)
                                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                                            .fill(Color.red)
                                                            .opacity(0.3)
                                                            .frame(width: 100, height: 30)
                                                    }
                                                }
                                                
                                            }
                                            .padding(25)
                                            .frame(width: 345)
                                            .cornerRadius(8)
                                            Rectangle() // Add a red line divider after each record
                                                                                            .fill(Color.red)
                                                                                            .frame(height: 1)
                                         
                                        }
                                        .padding(.vertical, 12)
                                        .padding(.horizontal)
                                        .frame(width: 350, height: 70)
                                        .cornerRadius(8)
                                        .gesture(
                                            DragGesture()
                                                .onEnded { value in
                                                    if value.translation.width < -100 {
                                                        deleteRecord(record)
                                                    }
                                                }
                                        )
                                    }.padding(.top, 10)
                                }
                                .padding()
                            }
                        }
                        
                        
                    }
                    Spacer()
                }
                .padding()
                .onAppear {
                    records = RecordManager.shared.fetchRecords()
                }
            }
        }
        
    }
    private func deleteRecord(_ record: AngleRecord) {
        if let index = records.firstIndex(where: { $0.id == record.id }) {
            records.remove(at: index)
                    RecordManager.shared.deleteRecord(record)
            
        }
    }
    
    
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .medium
    formatter.timeStyle = .none
    
    return formatter
}()

#Preview {
    
    mainView()
}
