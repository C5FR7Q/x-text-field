//
//  XTextField.swift
//  x-text-field
//
//  Created by Слава on 07.05.2024.
//

import SwiftUI

struct XTextField: View {
    
    var text: String
    
    var isEnabled: Bool = true
    var hasError: Bool = false
    
    var label: String = ""
    var placeholder: String = ""
    
    var trailingImage: UIImage? = nil
    
    var captionText: String? = nil
    
    var onTextChange: (String) -> Void
    
    var onTrailingImageClick: () -> Void = { }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            let shouldUseLabel = true // Изменим после
            Text(label)
                .font(labelFont)
                .foregroundColor(labelColor)
                .opacity(shouldUseLabel ? 1 : 0)
            
            Spacer().frame(height: 8)
            
            HStack(alignment: .center, spacing: 0) {
                ZStack(alignment: .leading) {
                    Text(placeholder)
                        .font(placeholderFont)
                        .foregroundColor(placeholderColor)
                        .opacity(shouldUseLabel ? 0 : 1)
                    textField()
                        .font(textFont)
                        .foregroundColor(textColor)
                        .accentColor(cursorColor)
                }
                
                if let trailingImage = trailingImage {
                    Spacer().frame(width: 16)
                    Image(uiImage: trailingImage)
                        .foregroundColor(trailingImageColor)
                        .frame(width: 24, height: 24, alignment: .center)
                        .onTapGesture { onTrailingImageClick() }
                }
            }.frame(minHeight: 24)
            
            ZStack {
                Spacer()
                Rectangle()
                    .fill(underlineColor)
                    .frame(height: 1)
            }.frame(height: 16, alignment: .bottom)
            
            if let captionText = captionText {
                Spacer().frame(height: 8)
                Text(captionText)
                    .font(captionFont)
                    .foregroundColor(captionColor)
            }
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
    }
    
    @ViewBuilder
    private func textField() -> some View {
        TextField("", text: Binding(
            get: { text },
            set: { onTextChange($0) }
        ))
    }
}

// MARK: Colors
private extension XTextField {
    
    var labelColor: Color { Color.gray }
    
    var placeholderColor: Color { Color.gray }
    
    var textColor: Color { Color.black }
    
    var cursorColor: Color {
        if hasError {
            Color.red
        } else {
            Color.green
        }
    }
    
    var underlineColor: Color {
        if hasError {
            Color.red
        } else {
            Color.gray
        }
    }
    
    var captionColor: Color {
        if hasError {
            Color.red
        } else {
            Color.gray
        }
    }
    
    var trailingImageColor: Color { Color.gray }
}

// MARK: Fonts
private extension XTextField {
    
    var labelFont: Font { Font.caption }
    
    var placeholderFont: Font { Font.body }
    
    var textFont: Font { Font.body }
    
    var captionFont: Font { Font.caption }
}
