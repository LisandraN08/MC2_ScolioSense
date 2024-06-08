//
//  cobaHistory.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 08/06/24.
//

import SwiftUI

struct cobaHistory: View {
    var body: some View {
        ScrollView {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(hex: "81C9F3", transparency: 1.0), lineWidth: 1)
                        .frame(width: 345)
                        .padding()
                    
                    VStack(spacing: 0) {
                        
                        ForEach(0..<15) { index in
                            VStack {
                            HStack(spacing: 20) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text("Date")
                                            .opacity(0.5)
                                        
                                        Text("Angle")
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                            .foregroundColor(Color(hex: "000000", transparency: 1.0))
                                    }
                                    Spacer()
                                }.padding(25)
                                
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Text("Normal").opacity(0.5)
                                        
                                        RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                            .fill(Color.green)
                                            .opacity(0.2)
                                            .frame(width: 90, height: 30)
                                    }
                                }.padding(.trailing, 20)
                               
                            }.frame(width: 345)
                            if index != 14 {
                                Divider()
                                    .background(Color.red.opacity(1.0))
                                    .frame(width: 300)
                            }
                                Spacer() // Center the content vertically within the row

                        }
                        }
                    }
                }.padding()

                
            }
            
            
            
            //xray
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 22)
                        .fill(Color(hex: "81C9F3", transparency: 0.5))
                        .frame(width: 348, height: 119)
                    HStack(spacing:0) {
                        Image("xray")
                            .resizable().frame(width: 43, height: 44)
                            .offset(x:15)
                        
                        
                        VStack(spacing:5) {
                            
                            HStack(spacing:5) {
                                //Scan your Back
                                Text("X-ray Scan").font(.system(size: 22, weight: .medium, design: .rounded)).foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7)))
                                
                                Image(systemName: "chevron.right")
                                    .resizable()
                                    .frame(width: 8, height: 8)
                                    .padding(.top,5)                  .foregroundColor(.black.opacity(0.7))
                                    .padding(.leading)
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
            }.padding(.top,20)
            
            ForEach(0..<15) { _ in
                VStack(alignment: .leading) {
                    HStack(spacing:50) {
                        let recordAbs = 10
                        if recordAbs <= 10 {
                            
                            ZStack {
                                Text("Normal").opacity(0.7).foregroundColor(.green)
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(Color.green)
                                    .opacity(0.1)
                                    .frame(width: 90, height: 30)
                            }
                            
                        } else if recordAbs < 20 {
                            ZStack {
                                Text("Mild").opacity(0.7)
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(Color.yellow)
                                    .opacity(0.3)
                                    .frame(width: 90, height: 30)
                            }
                        } else if recordAbs < 40 {
                            ZStack {
                                Text("Moderate").opacity(0.7)
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(Color.orange)
                                    .opacity(0.3)
                                    .frame(width: 90, height: 30)
                            }
                        } else {
                            ZStack {
                                Text("Severe").opacity(0.7)
                                RoundedRectangle(cornerSize: CGSize(width: 20, height: 20))
                                    .fill(Color.red)
                                    .opacity(0.3)
                                    .frame(width: 90, height: 30)
                            }
                        }
                        VStack(alignment:.leading) {
                            Text("blablaa")
                            
                            Text("111")
                                .font(.system(size: 20)) // Increased font size
                        }
                    }
                    //                                    VStack {
                    //                                        Text("Date: \(record.date, formatter: dateFormatter)")
                    //                                        Text("\(record.angle, specifier: "%.2f")°")
                    //
                    //                                    }
                }
                .padding(.vertical,12)
                .padding(.horizontal)
                .frame(width: 350, height:70)
                .ignoresSafeArea(.all)
                .edgesIgnoringSafeArea(.all)
                .background(Color(hex: "81C9F3", transparency: 0.1))
                .cornerRadius(8)
                
                
            }
        }
    }
}


#Preview {
    cobaHistory()
}
