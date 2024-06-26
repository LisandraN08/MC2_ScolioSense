//
//  AngleRecord.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 04/06/24.
//

import Foundation

struct AngleRecord: Identifiable, Codable, Equatable {
    var id = UUID()
    var angle: Double
    var date: Date
    
    static func == (lhs: AngleRecord, rhs: AngleRecord) -> Bool {
            return lhs.id == rhs.id
        }
}
