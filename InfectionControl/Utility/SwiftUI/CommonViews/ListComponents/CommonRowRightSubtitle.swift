//
//  CommonRowRightSubtitle.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

// Equivalent of TableViewCellStyleValue1
/* Note on Use: Trailing closures more likely to default to subtitleContent (only 3rd init(subtitle:titleContent:) doesn't) */
struct CommonRowRightSubtitle<TitleContent: View, SubtitleContent: View>: View, FullTitleStyling {
    var title: String?
    var titleContent: TitleContent
    var subtitle: String?
    var subtitleContent: SubtitleContent

    var titleFont: Font?
    var subtitleFont: Font?
    // TODO: Further layout customization (height, width, fontWeight?)
    
    // MARK: Initializers
    // Basic Layout
    init(title: String, subtitle: String) where TitleContent == EmptyView, SubtitleContent == EmptyView {
        self.title = title
        self.titleContent = EmptyView()
        self.subtitle = subtitle
        self.subtitleContent = EmptyView()
    }
    // Substitute subtitle with custom view
    init(title: String, @ViewBuilder subtitleContent: () -> SubtitleContent) where TitleContent == EmptyView {
        self.title = title
        self.titleContent = EmptyView()
        self.subtitle = nil
        self.subtitleContent = subtitleContent()
    }
    // Substitute title with customview
    init(subtitle: String, @ViewBuilder titleContent: () -> TitleContent) where SubtitleContent == EmptyView {
        self.title = nil
        self.titleContent = titleContent()
        self.subtitle = subtitle
        self.subtitleContent = EmptyView()
    }
    // Substitute both with custom views
    init(@ViewBuilder titleContent: () -> TitleContent, @ViewBuilder subtitleContent: () -> SubtitleContent) {
        self.titleContent = titleContent()
        self.subtitleContent = subtitleContent()
    }

    var body: some View {
        // Probably not able to further condense conditionals since func signatures look the same BUT are not actually the same.
        if let title = title, let subtitle = subtitle {
            CommonRow(title: title, extraContent: Text(subtitle).font(subtitleFont ?? .headline)
                .foregroundStyle(UIColor.black.withAlphaComponent(0.7).color)
                .frame(minWidth:30).lineLimit(1)).titleFont(titleFont)
        }
        else if let title = title {
            CommonRow(title: title, extraContent: subtitleContent).titleFont(titleFont)
        }
        else if let subtitle = subtitle {
            CommonRow(titleContent: titleContent, extraContent: Text(subtitle).font(subtitleFont ?? .headline)
                .foregroundStyle(UIColor.black.withAlphaComponent(0.7).color)
                .frame(minWidth:30).lineLimit(1))
        }
        else { CommonRow(titleContent: titleContent, extraContent: subtitleContent) }
    }
}

struct CommonRowRightSubtitle_Previews: PreviewProvider {
    static var previews: some View {
        // MARK: This Group demonstrates how to use each initializer of this common view component
        Group {
            // Default usage with simple strings
            CommonRowRightSubtitle(title: "Hello", subtitle: "World!")
            // Can customize fonts!
            CommonRowRightSubtitle(title: "Hello Font", subtitle: "Font World!").titleFont(.largeTitle).subtitleFont(.caption)
            // TitleContent trailing closure with default subtitle string
            CommonRowRightSubtitle(subtitle: "World!") { VStack { Text("Hello3"); Text("World3") } }
            // SubtitleContent trailing closure with default title string
            CommonRowRightSubtitle(title: "Hello") { VStack { Text("Hello2"); Text("World2") } }
            // SubtitleContent trailing closure with titleContent named closure
            CommonRowRightSubtitle(titleContent: { VStack { Text("Hello4"); Text("World4") } }) {
                VStack { Text("Hello5"); Text("World5") }
            }
        }.previewLayout(.fixed(width: 350, height: 100))
    }
}
