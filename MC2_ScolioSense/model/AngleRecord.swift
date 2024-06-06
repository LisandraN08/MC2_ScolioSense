//
//  AngleRecord.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 04/06/24.
//

import Foundation

struct AngleRecord: Identifiable, Codable {
    var id = UUID()
    var angle: Double
    var date: Date
}
