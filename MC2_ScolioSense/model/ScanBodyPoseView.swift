//
//  ScanBodyPoseView.swift
//  MC2_ScolioSense
//
//  Created by Lisandra Nicoline on 22/05/24.
//

import SwiftUI
import Vision
import CoreGraphics
import Combine
import UIKit

struct ScanBodyPoseView: View {
    @StateObject private var viewModel = ImageProcessingViewModel()

    var body: some View {
        VStack {
            if let image = viewModel.processedUIImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 500, height: 500)
                    .onAppear {
                        print("Displaying processed image")
                    }
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                    .foregroundColor(.gray)
                    .onAppear {
                        print("Displaying placeholder image")
                    }
            }

            HStack {
                Button("Load Image") {
                    viewModel.showImagePicker = true
                    viewModel.sourceType = .photoLibrary
                }
                .padding()

                Button("Take Picture") {
                    viewModel.showImagePicker = true
                    viewModel.sourceType = .camera
                }
                .padding()
            }
                


            if viewModel.isProcessing {
                ProgressView()
            }

            
            if let relativeAngle = viewModel.relativeAngle {
                Text("Relative Angle: \(relativeAngle)°")
                    .padding()
                    .foregroundColor(.black)
                    .font(.headline)
            }
            
            if let severityText = viewModel.severityText {
                Text("Severity: \(severityText)")
                    .padding()
                    .foregroundColor(.red)
                    .font(.headline)
            }
            

//            Button("Save Image") {
//                if let image = viewModel.processedUIImage {
//                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                }
//            }
//            .padding()
//            .disabled(viewModel.processedUIImage == nil)
        }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(sourceType: viewModel.sourceType, selectedImage: $viewModel.originalUIImage)
        }
        .onChange(of: viewModel.originalUIImage) { _ in
            viewModel.processImage()
        }
    }
}



class ImageProcessingViewModel: ObservableObject {
    @Published var originalUIImage: UIImage?
    @Published var processedUIImage: UIImage?
    @Published var isProcessing = false
    @Published var processingDuration: Double?
    @Published var showImagePicker = false
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var isBodyPoseRequired = true
    
    @Published var relativeAngle: CGFloat? {
        didSet {
            if let relativeAngle = relativeAngle {
                severityText = getSeverityText(for: Double(relativeAngle))
            }
        }
    }
    @Published var severityText: String?
    
    private let visionQueue = DispatchQueue.global(qos: .userInitiated)
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        $originalUIImage
            .sink { [weak self] _ in
                self?.processImage()
            }
            .store(in: &cancellables)
    }
    
    func toggleBodyPoseDetection() {
        isBodyPoseRequired.toggle()
        processImage()
        print("Processing Image with Body Pose Detection: \(isBodyPoseRequired)")
    }
    
    func processImage() {
        guard let image = originalUIImage, let cgImage = image.cgImage else { return }
        
        let isProcessingRequired = isBodyPoseRequired
        
        guard isProcessingRequired else {
            DispatchQueue.main.async {
                self.processedUIImage = self.originalUIImage
            }
            return
        }
        
        isProcessing = true
        processingDuration = nil
        
        visionQueue.async { [weak self] in
            guard let self = self else { return }
            
            let request = VNDetectHumanBodyPoseRequest { request, error in
                DispatchQueue.main.async {
                    if let results = request.results as? [VNHumanBodyPoseObservation] {
                        print("Found \(results.count) human body pose observations")
                        self.processedUIImage = self.drawBodyPose(on: image, using: results)
                        if self.processedUIImage != nil {
                            print("Processed image updated in UI")
                        } else {
                            print("Processed image is nil")
                        }
                    } else {
                        print("No body pose observations found")
                        self.processedUIImage = image
                    }
                    self.isProcessing = false
                }
            }
            
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                let start = Date()
                try handler.perform([request])
                let duration = Date().timeIntervalSince(start)
                DispatchQueue.main.async {
                    self.processingDuration = duration
                }
            } catch {
                print("Failed to perform request: \(error)")
                DispatchQueue.main.async {
                    self.isProcessing = false
                }
            }
        }
    }
    
    private func drawBodyPose(on image: UIImage, using observations: [VNHumanBodyPoseObservation]) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: .zero, size: image.size))

        guard let context = UIGraphicsGetCurrentContext() else {
            print("Failed to create context")
            return nil
        }

        context.setLineWidth(2.0) // Set the line width for drawing connections

        for observation in observations {
            let jointPairs: [(VNHumanBodyPoseObservation.JointName, VNHumanBodyPoseObservation.JointName)] = [
                (.leftShoulder, .leftElbow), (.leftElbow, .leftWrist),
                (.rightShoulder, .rightElbow), (.rightElbow, .rightWrist),
                (.leftHip, .leftKnee), (.leftKnee, .leftAnkle),
                (.rightHip, .rightKnee), (.rightKnee, .rightAnkle),
                (.leftShoulder, .leftHip), (.rightShoulder, .rightHip),
                (.leftShoulder, .rightShoulder), (.leftHip, .rightHip)
            ]

            let jointNames: [VNHumanBodyPoseObservation.JointName] = [
                .nose, .leftEye, .rightEye, .leftEar, .rightEar,
                .leftShoulder, .rightShoulder, .leftElbow, .rightElbow,
                .leftWrist, .rightWrist, .leftHip, .rightHip,
                .leftKnee, .rightKnee, .leftAnkle, .rightAnkle
            ]

            var jointPoints: [VNHumanBodyPoseObservation.JointName: CGPoint] = [:]

            for jointName in jointNames {
                if let point = try? observation.recognizedPoint(jointName), point.confidence > 0.1 {
                    let translatedPoint = point.location.translateFromCoreImageToUIKitCoordinateSpace(using: image.size.height)
                    context.addArc(center: translatedPoint, radius: 5.0, startAngle: 0, endAngle: .pi * 2, clockwise: true)
                    context.setFillColor(UIColor.red.cgColor)
                    context.fillPath()
                    print("Drawing joint \(jointName.rawValue) at point \(translatedPoint)")
                    jointPoints[jointName] = translatedPoint
                }
            }

            // Draw lines connecting the joints
            context.setStrokeColor(UIColor.green.cgColor) // Set the color for the lines
            for (jointA, jointB) in jointPairs {
                if let pointA = jointPoints[jointA], let pointB = jointPoints[jointB] {
                    context.move(to: pointA)
                    context.addLine(to: pointB)
                    context.strokePath()
                }
            }
            if let leftShoulderPoint = jointPoints[.leftShoulder],
               let rightShoulderPoint = jointPoints[.rightShoulder] {
                
                let angle = calculateAngleBetweenPoints(leftPoint: leftShoulderPoint, rightPoint: rightShoulderPoint)
                var severityLevel = 0
                var relativeAngle = abs(90 - angle) // Menghitung sudut kemiringan relatif terhadap 90 derajat
                
                // Jika sudut relatif lebih besar dari 90 derajat, kurangkan dari 180 derajat
                if relativeAngle > 90 {
                    relativeAngle = 180 - relativeAngle
                }
                severityLevel = Int(relativeAngle)
                
                // Setel nilai relativeAngle di dalam model
                self.relativeAngle = relativeAngle
                
                print("Sudut kemiringan antara leftShoulder dan rightShoulder adalah \(relativeAngle) derajat")
            }



        }

        let processedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("Processed image successfully")
        return processedImage
    }
    
    private func getSeverityText(for relativeAngle: Double) -> String {
        let relativeAngle = abs(relativeAngle)
        if relativeAngle > 40 {
            return "Severe"
        } else if relativeAngle > 20 {
            return "Moderate"
        } else if relativeAngle > 10 {
            return "Mild"
        } else {
            return "Normal"
        }
        
        }

}

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker

        init(parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }

    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

extension CGPoint {
    func translateFromCoreImageToUIKitCoordinateSpace(using imageHeight: CGFloat) -> CGPoint {
        let translatedPoint = CGPoint(x: self.x, y: imageHeight - self.y)
        print("Translating point from \(self) to \(translatedPoint) using image height \(imageHeight)")
        return translatedPoint
    }
}

extension CGFloat {
    var degrees: CGFloat {
        return self * 180 / .pi
    }
}

func calculateAngleBetweenPoints(leftPoint: CGPoint, rightPoint: CGPoint) -> CGFloat {
    let dy = rightPoint.y - leftPoint.y
    let dx = rightPoint.x - leftPoint.x
    let radians = atan2(dy, dx)
    let degrees = radians.degrees
    return degrees
}

func processBodyPoseObservations(_ observations: [VNHumanBodyPoseObservation]) {
    for observation in observations {
        if let leftShoulderPoint = try? observation.recognizedPoint(.leftShoulder),
           let rightShoulderPoint = try? observation.recognizedPoint(.rightShoulder) {
            
            let leftShoulder = CGPoint(x: leftShoulderPoint.location.x, y: 1 - leftShoulderPoint.location.y)
            let rightShoulder = CGPoint(x: rightShoulderPoint.location.x, y: 1 - rightShoulderPoint.location.y)
            
            print("Koordinat leftShoulder: \(leftShoulder)")
            print("Koordinat rightShoulder: \(rightShoulder)")
            
            let angle = calculateAngleBetweenPoints(leftPoint: leftShoulder, rightPoint: rightShoulder)
            let adjustedAngle = angle < 0 ? 180 + angle : angle // Menyesuaikan sudut ke rentang 0-180 derajat jika perlu
            
            print("Sudut kemiringan antara leftShoulder dan rightShoulder adalah \(adjustedAngle) derajat")
        }
    }
}

// Fungsi untuk mendeteksi pose tubuh dari gambar
func detectBodyPose(from image: UIImage) {
    guard let cgImage = image.cgImage else { return }
    
    let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
    let bodyPoseRequest = VNDetectHumanBodyPoseRequest { request, error in
        if let error = error {
            print("Error detecting body pose: \(error)")
            return
        }
        
        guard let observations = request.results as? [VNHumanBodyPoseObservation] else { return }
        processBodyPoseObservations(observations)
    }
    
    do {
        try requestHandler.perform([bodyPoseRequest])
    } catch {
        print("Failed to perform body pose request: \(error)")
    }
}



