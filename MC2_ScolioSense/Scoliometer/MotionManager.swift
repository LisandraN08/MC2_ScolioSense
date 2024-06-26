//
//  MotionManager.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 29/05/24.
//
import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    
    private var motionManager: CMMotionManager
    private var filteredPitch: Double = 0.0
    private let filterFactor = 0.1

    @Published var slopeDegrees: Double = 0.0
    var isPaused: Bool = false

    init() {
        motionManager = CMMotionManager()
        startDeviceMotionUpdates()
    }

    public func startDeviceMotionUpdates() {
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0

        motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { [weak self] (motion, error) in
            if let motion = motion {
                self?.updateSlopeDegrees(from: motion.attitude)
            } else if let error = error {
                print("Error receiving device motion updates: \(error.localizedDescription)")
            }
        }
    }

    private func updateSlopeDegrees(from attitude: CMAttitude) {
        guard !isPaused else { return }
        let pitch = attitude.pitch.radiansToDegrees

        filteredPitch = filterFactor * pitch + (1 - filterFactor) * filteredPitch
        self.slopeDegrees = filteredPitch
    }

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}

extension Double {
    var radiansToDegrees: Double {
        return self * 180 / .pi
    }
}



