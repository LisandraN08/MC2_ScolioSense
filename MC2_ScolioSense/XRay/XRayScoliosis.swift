//
//  XRayScoliosis.swift
//  MC2_ScolioSense
//
//  Created by Jonathan Zeann Philibert Samuel on 03/06/24.
//

import SwiftUI
import PhotosUI
import SwiftData

@MainActor
final class XRayScoliosisModel: ObservableObject {
    
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data) {
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
}

struct XRayScoliosis: View {
    @State var y: Double = 0
    @StateObject private var viewModel = XRayScoliosisModel()
    @State var showingSeeMoreSheet = false
    @State var showGuidanceSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Cobb's Angle").font(.system(size: 35))
                        .fontWeight(.bold)
                    Spacer()
                                            HStack {
                                                PhotosPicker(
                                                    selection: $viewModel.imageSelection,
                                                    matching: .images)
                                                {
                                                    Image("Photo1")
                                                }
                                                .frame(alignment: .leading)
                                                .frame(width: 35, height: 35)
                    
                                            }
                                            .opacity(0.4)
                }.padding()
                ZStack {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 330, height: 450)
                            .cornerRadius(10)
                            .position(x:500, y:50)
                    }
                    
                    CobbsLine(y:$y)
                    
                    VStack {
                        Spacer()
                        Spacer()

                    }.padding()
                }
                HStack {
                    Button("How to use") {
                        showingSeeMoreSheet.toggle()
                    }
                    .frame(width: 100, height:100)
                    .bold()
                }
                .sheet(isPresented: $showingSeeMoreSheet) {
                    seeMoreSheetView()
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                }
            }
        }
    }
}

struct seeMoreSheetView: View {
    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    Image("scoliosis1")
                }
                Text("1. Put the line onto the lower vertebrae that curves")
                    .frame(width: 300, alignment: .leading)
                Text("2. Adjust the circle to make the line aligned with the vertebrae line")
                    .frame(width: 300, alignment: .leading)
                Text("3. Repeat step 1-2 for upper vertebrae")
                    .frame(width: 300, alignment: .leading)
            }.navigationTitle("Guidance")
        }
    }
}

struct XRayScoliosis_Previews: PreviewProvider {
    static var previews: some View {
        XRayScoliosis()
    }
}
