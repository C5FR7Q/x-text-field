//
//  XTextField.swift
//  x-text-field
//
//  Created by Слава on 16.05.2024.
//

import SwiftUI

struct XTextField: View {
    
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
        onTrailingImageClick: @escaping () -> Void = { }
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
    }
    
    var body: some View {
        FocusHolderView { focusBinding in
            XTextField_Base(
                text: text,
                currentText: currentText,
                isEnabled: isEnabled,
                hasError: hasError,
                isSecureTextEntry: isSecureTextEntry,
                label: label,
                placeholder: placeholder,
                trailingImage: trailingImage,
                captionText: captionText,
                onTextChange: onTextChange,
                onTrailingImageClick: onTrailingImageClick,
                focusField: focusBinding
            )
        }
    }
}
