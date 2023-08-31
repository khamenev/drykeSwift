//
//  RecommendationResponse.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import Foundation

struct ForecastResponse: Codable {
    let data: ForecastData?
    let error: String?
}

struct ForecastData: Codable {
    let isRecommended: Bool
    let recommendations: [String]?
    let rejectReasons: [String]?
}
