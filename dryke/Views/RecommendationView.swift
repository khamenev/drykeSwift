//
//  RecommendationView.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import SwiftUI

struct RecommendationView: View {
    @ObservedObject var viewModel: DryOrNotViewModel
    
    var body: some View {
        VStack {
            if viewModel.isRecommended {
                Text("It's a good day for drying!")
                    .foregroundColor(.green)
           
            } else {
                Text("Not recommended to dry due to:")
                    .foregroundColor(.red)
                ForEach(viewModel.rejectReasons, id: \.self) { reason in
                    Text(reason)
                }
            }
        }
    }
}
