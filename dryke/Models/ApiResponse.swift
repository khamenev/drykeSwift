//
//  ApiResponse.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import Foundation

struct ApiResponse: Codable {
    let data: Recommendation?
    let error: String?
}

struct Recommendation: Codable {
    let isRecommended: Bool
    let recommendations: [String]?
    let rejectReasons: [String]?
}

struct RecommendationResponse: Codable {
    var data: RecommendationData
    var error: String?
    
    struct RecommendationData: Codable {
        var isRecommended: Bool
        var recommendations: [String]?
        var rejectReasons: [String]?
    }
}
