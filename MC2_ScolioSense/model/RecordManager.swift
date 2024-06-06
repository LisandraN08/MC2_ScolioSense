//
//  RecordManager.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 04/06/24.
//

import Foundation

class RecordManager {
    static let shared = RecordManager()
    private let userDefaultsKey = "angleRecords"

    private init() {}

    func saveRecord(_ record: AngleRecord) {
        var records = fetchRecords()
        records.append(record)
        if let encoded = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    func fetchRecords() -> [AngleRecord] {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let records = try? JSONDecoder().decode([AngleRecord].self, from: data) {
            return records
        }
        return []
    }
}
