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
                ZStack {
                    if let image = viewModel.selectedImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 500)
                            .cornerRadius(10)
                            .position(x:200, y:310)
                    }
                    
                    CobbsLine(y:$y)
                    
                    VStack {
                        Spacer()
                        PhotosPicker(
                            selection: $viewModel.imageSelection,
                            matching: .images
                        ) {
                            Image("Photo1")
                                .padding()
                        }
                    }
                    .position(x:340,y:-205)
                    .opacity(0.4)
                }
                HStack {
                    Button("See more") {
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
            }.navigationTitle("Cobb's Angle")
        }
    }
}

struct seeMoreSheetView: View {
    var body: some View {
        NavigationView {
            Form {
                Text("Degree of Spinal Curve:")
            }.navigationTitle("Cobb's Result")
        }
    }
}

struct guidanceSheetView: View {
    var body: some View {
        Text("ayam")
    }
}

struct XRayScoliosis_Previews: PreviewProvider {
    static var previews: some View {
        XRayScoliosis()
    }
}
