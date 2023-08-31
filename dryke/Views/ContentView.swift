//
//  ContentView.swift
//  dryke
//
//  Created by Sergey Khamenev on 26/08/2023.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = DryOrNotViewModel()
    
    var body: some View {
        NavigationView {
            RecommendationView(viewModel: viewModel)
                .navigationTitle("Dry or Not")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
