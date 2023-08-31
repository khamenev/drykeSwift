//
//  ForecastResponse.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

struct ForecastResponse: Codable {
    let data: ForecastData?
    let error: String?
}

struct ForecastData: Codable {
    let isRecommended: Bool
    let recommendations: [String]?
    let rejectReasons: [String]?
}

extension ForecastResponse {
    static let forecastData = ForecastData(isRecommended: true, recommendations: [], rejectReasons: [])
    static let forecastResponse = ForecastResponse(data: forecastData, error: nil)
}

