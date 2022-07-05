//
//  CommonRowSubtitled.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

struct CommonRowSubtitled<Content: View>: View, FullTitleStyling {
    var imageName: String?
    var title: String?
    var titleContent: Content
    var subtitle: String?
    
    var titleFont: Font?
    var subtitleFont: Font?
    
    // MARK: Initializers
    // Standard version based on CellStyleSubtitle
    init(title: String, subtitle: String, imageName: String? = nil) where Content == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
        self.titleContent = EmptyView()
    }
    // A bit more customized set of title views but in similar style
    init(imageName: String? = nil, @ViewBuilder titleContent: () -> Content) {
        self.imageName = imageName
        self.titleContent = titleContent()
    }
    
    var body: some View {
        if let title = title, let subtitle = subtitle {
            CommonRow(imageName: imageName, titleContent: {
                VStack(alignment: .leading, spacing: 6) {
                    Text(title).font(titleFont ?? .headline)
                    Text(subtitle).font(subtitleFont ?? .body).padding(.leading, 7)
                }
            })
        }
        else {
            CommonRow(imageName: imageName, titleContent: {
                VStack(alignment: .leading, spacing: 6) { titleContent }
            })
        }
    }
}


struct CommonRowSubtitled_Previews: PreviewProvider {
    static var previews: some View {
        var view = CommonRowSubtitled(title: "Hello", subtitle: "World!")
        view.titleFont = .title
        return Group {
            // Default simple title and subtitle
            CommonRowSubtitled(title: "Hello", subtitle: "World!")
            view // Manually updating titleFont property
            // OR fluent new and improved way with titleFont/subtitleFont methods!
            CommonRowSubtitled(title: "Hello Font!", subtitle: "Font World!").titleFont(.title).subtitleFont(.largeTitle)
            // Could include an image icon!
            CommonRowSubtitled(title: "Hello", subtitle: "World!", imageName: "report_placeholder_icon")
            // Custom title view! (Can add 2+ subtitles underneath it!)
            CommonRowSubtitled {
                Text("Hello World").font(.headline)
                Text("Hello World 2").font(.body).padding(.leading, 7)
                Text("Hello World 3").font(.body).padding(.leading, 7)
            }
            // Could also include an image with your custom title view.
            CommonRowSubtitled(imageName: "report_placeholder_icon") {
                Text("Hello World").font(.headline)
                Text("Hello World 2").font(.body).padding(.leading, 7)
                Text("Hello World 3").font(.body).padding(.leading, 7)
            }
        }.previewLayout(.fixed(width: 350, height: 100))
    }
}
