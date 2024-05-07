//
//  XScreen.swift
//  x-text-field
//
//  Created by Слава on 07.05.2024.
//

import SwiftUI

struct XScreen: View {
    
    @State private var text1 = "TextField1"
    @State private var text2 = "TextField2"
    
    var body: some View {
        VStack {
            XTextField(
                text: text1,
                hasError: false,
                label: "TextField1",
                placeholder: "TextField1",
                trailingImage: UIImage.add.withRenderingMode(.alwaysTemplate),
                captionText: "TextField1",
                onTextChange: { text in
                    text1 = text
                    print("TextField1: text changed to \(text)")
                }
            ).padding(20)
            
            XTextField(
                text: text2,
                hasError: true,
                label: "TextField2",
                placeholder: "TextField2",
                trailingImage: UIImage.add.withRenderingMode(.alwaysTemplate),
                captionText: "TextField2",
                onTextChange: { text in
                    text2 = text
                    print("TextField2: text changed to \(text)")
                }
            ).padding(20)
        }
    }
}
