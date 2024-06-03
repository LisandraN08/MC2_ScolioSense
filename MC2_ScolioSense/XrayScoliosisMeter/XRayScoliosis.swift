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
  
    var body: some View {
        VStack {
            ZStack {
                if let image = viewModel.selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 350, height: 500)
                        .cornerRadius(10)
                        .position(x:200, y:300)
                }
                
                CobbsLine(y:$y)

                VStack {
                    Spacer()
                    PhotosPicker(
                        selection: $viewModel.imageSelection,
                        matching: .images
                    ) {
                        Image("ButtonInsert")
                            .padding()
                    }
                    }
                }
            }
        }
    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        XRayScoliosis()
    }
}
