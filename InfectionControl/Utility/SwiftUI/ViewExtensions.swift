//
//  ViewExtensions.swift
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
    
    // MARK: List Extensions
    // Simplify the init process, keeping same anticlockwise pattern of (top, leading, bottom, trailing)
    func listRowInsets(_ top: CGFloat, _ leading: CGFloat, _ bottom: CGFloat, _ trailing: CGFloat) -> some View {
        return self.listRowInsets(.init(top: top, leading: leading, bottom: bottom, trailing: trailing))
    }
    // Creates a list row without any insets (edge to edge) - Maybe needs a better name?
    func flushListRow() -> some View {
        return self.listRowInsets(0, 0, 0, 0) // Question: Is this the equivalent of listRowInsets(nil)
    }
}

struct ViewExtensions_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Hello World!")
        }.addNetworkIndicator(isRefreshing: true, title: "Loading", color: .red)
            .previewLayout(.fixed(width: 350, height: 300))
    }
}
