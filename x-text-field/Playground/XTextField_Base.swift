//
//  XTextField_Base.swift
//  x-text-field
//
//  Created by Слава on 07.05.2024.
//

import SwiftUI

struct XTextField_Base: View {
    
    var text: String
    var currentText: (() -> String)? = nil
    
    var isEnabled: Bool = true
    var hasError: Bool = false
    var isSecureTextEntry: Bool = false
    
    var label: String = ""
    var placeholder: String = ""
    
    var trailingImage: UIImage? = nil
    
    var captionText: String? = nil
    
    var onTextChange: (String) -> Void
    
    var onTrailingImageClick: () -> Void = { }
    
//    @FocusState
//    var focusField: FocusField?
    var focusField: FocusState<FocusField?>.Binding
    @State
    private var internalText: String
    
    init(
        text: String,
        currentText: (() -> String)? = nil,
        isEnabled: Bool = true,
        hasError: Bool = false,
        isSecureTextEntry: Bool = false,
        label: String = "",
        placeholder: String = "",
        trailingImage: UIImage? = nil,
        captionText: String? = nil,
        onTextChange: @escaping (String) -> Void,
        onTrailingImageClick: @escaping () -> Void = { },
        focusField: FocusState<FocusField?>.Binding
    ) {
        self.text = text
        self.currentText = currentText
        self.isEnabled = isEnabled
        self.hasError = hasError
        self.isSecureTextEntry = isSecureTextEntry
        self.label = label
        self.placeholder = placeholder
        self.trailingImage = trailingImage
        self.captionText = captionText
        self.onTextChange = onTextChange
        self.onTrailingImageClick = onTrailingImageClick
        self._internalText = State(wrappedValue: text)
        self.focusField = focusField
    }
    
    var body: some View {
        let _ = Self._printChanges()
        VStack(alignment: .leading, spacing: 0) {
            let shouldUseLabel = isFocused || !internalText.isEmpty
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
//            focusField = isSecureTextEntry ? .secureField : .textField
            focusField.wrappedValue = isSecureTextEntry ? .secureField : .textField
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.4)
        .onChange(of: isSecureTextEntry) { newIsSecureTextEntry in
//            if focusField.wrappedValue != nil {
//                focusField.wrappedValue = newIsSecureTextEntry ? .secureField : .textField
//            }
            if focusField.wrappedValue != nil {
                focusField.wrappedValue = newIsSecureTextEntry ? .secureField : .textField
            }
        }
        .onChange(of: internalText) { newText in
            if newText != text {
                onTextChange(newText)
                if let currentText = currentText {
                    internalText = currentText()
                }
            }
        }
        .onChange(of: text) { newText in
            internalText = newText
        }
        .background(.random)
    }
    
    @ViewBuilder
    private func textField() -> some View {
        ZStack {
            TextField("", text: $internalText)
//                .focused($focusField, equals: .textField)
                .focused(focusField, equals: .textField)
                .opacity(isSecureTextEntry ? 0 : 1)
            
            SecureField("", text: $internalText)
//                .focused($focusField, equals: .secureField)
                .focused(focusField, equals: .secureField)
                .opacity(isSecureTextEntry ? 1 : 0)
        }
    }
    
    var isFocused: Bool {
//        focusField != nil
        focusField.wrappedValue != nil
    }
}

// MARK: Colors
private extension XTextField_Base {
    
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
private extension XTextField_Base {
    
    var labelFont: Font { Font.caption }
    
    var placeholderFont: Font { Font.body }
    
    var textFont: Font { Font.body }
    
    var captionFont: Font { Font.caption }
}

extension XTextField_Base {
    
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
