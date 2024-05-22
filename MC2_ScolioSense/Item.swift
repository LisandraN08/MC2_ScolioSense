//
//  Item.swift
//  MC2_ScolioSense
//
//  Created by Lisandra Nicoline on 22/05/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
