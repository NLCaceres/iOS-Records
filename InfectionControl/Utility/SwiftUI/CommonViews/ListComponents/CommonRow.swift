//
//  CommonRow.swift
//  InfectionControl
//
//  Copyright © 2022 Nick Caceres. All rights reserved.

import SwiftUI

// Equivalent of TableViewCellStyleDefault. Also serves as base for other common styles
/* Note on Use: CANNOT use titleContent or extraContent as trailing closure,
 MUST specify paramName (i.e. CommonRow(titleContent: {})) or it defaults to extraContent */
struct CommonRow<TitleContent: View, ExtraContent: View>: View, TitleStyling {
    var imageName: String?
    var title: String?
    var titleContent: TitleContent
    var extraContent: ExtraContent

    var titleFont: Font?
    
    // MARK: Initializers
    // CellStyleDefault
    init(title: String, imageName: String? = nil) where TitleContent == EmptyView, ExtraContent == EmptyView {
        self.title = title
        self.imageName = imageName
        self.titleContent = EmptyView()
        self.extraContent = EmptyView()
    }
    // CellStyleDefault but no image (missing title text view so titleContent no longer works as cellStyleValue2)
    init(@ViewBuilder titleContent: () -> TitleContent) where ExtraContent == EmptyView {
        self.title = nil
        self.titleContent = titleContent()
        self.extraContent = EmptyView()
    }
    // CellStyleDefault but no image (able to pass Text() without wrapping in closure)
    init(titleContent: TitleContent) where ExtraContent == EmptyView {
        self.title = nil
        self.titleContent = titleContent
        self.extraContent = EmptyView()
    }
    // CellStyleValue1 but no img (title + right aligned view)
    init(titleContent: TitleContent, extraContent: ExtraContent) {
        self.title = nil
        self.titleContent = titleContent
        self.extraContent = extraContent
    }
    // CellStyleValue1 (img + title + right aligned subtitle view)
    init(title: String, imageName: String? = nil, @ViewBuilder extraContent: () -> ExtraContent) where TitleContent == EmptyView {
        self.title = title
        self.imageName = imageName
        self.titleContent = EmptyView()
        self.extraContent = extraContent()
    }
    // CellStyleValue1 (title + right aligned subtitle view)
    init(title: String, extraContent: ExtraContent) where TitleContent == EmptyView {
        self.title = title
        self.imageName = nil
        self.titleContent = EmptyView()
        self.extraContent = extraContent
    }
    // CellStyleValue2 (img + title + subtitle immediately after title)
    init(title: String? = nil, imageName: String? = nil, @ViewBuilder titleContent: () -> TitleContent) where ExtraContent == EmptyView {
        self.title = title
        self.imageName = imageName
        self.titleContent = titleContent()
        self.extraContent = EmptyView()
    }
    // CellStyleValue1+2 (img + title + subtitle immediately after title + a right aligned view)
    init(title: String? = nil, imageName: String? = nil, @ViewBuilder titleContent: () -> TitleContent,
                                                         @ViewBuilder extraContent: () -> ExtraContent) {
        self.title = title
        self.imageName = imageName
        self.titleContent = titleContent()
        self.extraContent = extraContent()
    }
    // Useful for functions that alter appearanace (like fonts!)
    init(title: String? = nil, imageName: String? = nil, titleContent: TitleContent, extraContent: ExtraContent) {
        self.title = title
        self.imageName = imageName
        self.titleContent = titleContent
        self.extraContent = extraContent
    }
    
    var body: some View {
        HStack(alignment: .center) {
            if let imageName = imageName {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
            }
            if let title = title {
                Text(title).font(titleFont ?? .title).fontWeight(.bold)
            }
            titleContent
            Spacer()
            extraContent
        }
    }
}

struct CommonRow_Previews: PreviewProvider {
    static var previews: some View {
        // MARK: This Group demonstrates how to use each initializer of this common view component
        Group {
            // Able to add padding around views
            CommonRow(title: "Hello World").padding(.horizontal, 5)
            // Able to add different title font
            CommonRow(title: "Hello Small World!").titleFont(.body)
            // CellStyleDefault
            CommonRow(title: "Hello World", imageName: "report_placeholder_icon")
            // CellStyleValue1
            CommonRow(title: "Hello World", extraContent: {
                Text("Hello World 3")
            }).padding(.horizontal, 15)
            // CellStyleValue2
            CommonRow(title: "Hello World", titleContent: {
                Text("Hello World 2!")
            }).padding(.horizontal, 5)
            // CellStyleSubtitle
            CommonRow(imageName:"report_placeholder_icon", titleContent: {
                VStack {
                    Text("Hello World 2!").font(.headline).fontWeight(.bold)
                    Text("Hello World!")
                }
            })
        }.previewLayout(.fixed(width: 350, height: 100))
    }
}
