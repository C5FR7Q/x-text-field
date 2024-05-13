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
    var isSecureTextEntry: Bool = false
    
    var label: String = ""
    var placeholder: String = ""
    
    var trailingImage: UIImage? = nil
    
    var captionText: String? = nil
    
    var onTextChange: (String) -> Void
    
    var onTrailingImageClick: () -> Void = { }
    
    @FocusState
    var focusField: FocusField?
    
    var body: some View {
        let _ = Self._printChanges()
        VStack(alignment: .leading, spacing: 0) {
            let shouldUseLabel = isFocused || !text.isEmpty
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
                        .textFieldStyle(.plain) // https://stackoverflow.com/a/74745555
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
                    .frame(height: isFocused ? 2 : 1)
            }.frame(height: 16, alignment: .bottom)
            
            if let captionText = captionText {
                Spacer().frame(height: 8)
                Text(captionText)
                    .font(captionFont)
                    .foregroundColor(captionColor)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            focusField = isSecureTextEntry ? .secureField : .textField
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
        .onChange(of: isSecureTextEntry) { newIsSecureTextEntry in
            if focusField != nil {
                focusField = newIsSecureTextEntry ? .secureField : .textField
            }
        }
        .background(.random)
    }
    
    @ViewBuilder
    private func textField() -> some View {
        ZStack {
            TextField("", text: Binding(
                get: { text },
                set: { onTextChange($0) }
            ))
                .focused($focusField, equals: .textField)
                .opacity(isSecureTextEntry ? 0 : 1)
            
            SecureField("", text: Binding(
                get: { text },
                set: { onTextChange($0) }
            ))
                .focused($focusField, equals: .secureField)
                .opacity(isSecureTextEntry ? 1 : 0)
        }
    }
    
    var isFocused: Bool {
        focusField != nil
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
            if isFocused {
                Color.black
            } else {
                Color.gray
            }
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

extension XTextField {
    
    enum FocusField {
        case textField, secureField
    }
}

extension View {
    
    @ViewBuilder
    public func preventPasswordReset() -> some View {
        onReceive(
            NotificationCenter.default.publisher(
                for: UITextField.textDidBeginEditingNotification
            )
        ) { obj in
            if let textField = obj.object as? UITextField {
                if textField.isSecureTextEntry {
                    let currentText = textField.text ?? ""
                    textField.text = ""
                    textField.insertText(currentText)
                }
            }
        }
    }
}

private extension ShapeStyle where Self == Color {
    static var random: Color {
        Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        )
    }
}
