//
//  datamodelTry.swift
//  MC2_ScolioSense
//
//  Created by Gwynneth Isviandhy on 30/05/24.
//

import Foundation

struct user {
    var name: String
    var age: Int?
    var date: String
    var overallDegree: Int
    var shoulderSlope: Int?
    var hipSlope: Int?
    var bodyTilt: Int?
    
    init(name: String, age: Int? = nil, date: String, overallDegree: Int, var shoulderSlope: Int?, var hipSlope: Int?, var bodyTilt: Int? ) {
        self.name = name
        self.age = age
        self.date = date
        self.overallDegree = overallDegree
        self.shoulderSlope = shoulderSlope
        self.hipSlope = hipSlope
        self.bodyTilt = bodyTilt
    }
}

