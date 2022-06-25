//
//  CommonViews.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

extension View {
    func addNetworkIndicator(isRefreshing: Bool, title: String, color: Color?) -> some View {
        return self.overlay(content:{ if isRefreshing {
            ProgressView(title).progressViewStyle(.circular)
                .tint(color ?? .blue).foregroundColor(color ?? .blue)
        }})
    }
}

struct CommonViews_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello World!")
        }.addNetworkIndicator(isRefreshing: true, title: "Loading", color: .blue)
    }
}
