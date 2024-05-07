//
//  XScreen.swift
//  x-text-field
//
//  Created by Слава on 07.05.2024.
//

import SwiftUI

class XObject<T>: ObservableObject {
    var value: T
    lazy var update: (T) -> Void = {
        { [weak self] newValue in
            guard let self = self else { return }
            self.value = newValue
            self.objectWillChange.send()
        }
    }()
    
    init(value: T) {
        self.value = value
    }
}

struct XScreen: View {
    
    @StateObject private var text1Object: XObject<String>
    @StateObject private var text2Object: XObject<String>
    
    private var onText1Change: (String) -> Void
    private var onText2Change: (String) -> Void
    
    init() {
        var text1Obj = XObject(value: "TextField1")
        var text2Obj = XObject(value: "TextField2")
        
        self._text1Object = StateObject(wrappedValue: text1Obj)
        self._text2Object = StateObject(wrappedValue: text2Obj)
        
        self.onText1Change = { text in
            text1Obj.update(text)
            print("TextField1: text changed to \(text)")
        }
        self.onText2Change = { text in
            text2Obj.update(text)
            print("TextField2: text changed to \(text)")
        }
    }
    
    var body: some View {
        VStack {
            XTextField(
                text: text1Object.value,
                hasError: false,
                label: "TextField1",
                placeholder: "TextField1",
                trailingImage: UIImage.add.withRenderingMode(.alwaysTemplate),
                captionText: "TextField1",
                onTextChange: onText1Change
            ).padding(20)
            
            XTextField(
                text: text2Object.value,
                hasError: true,
                label: "TextField2",
                placeholder: "TextField2",
                trailingImage: UIImage.add.withRenderingMode(.alwaysTemplate),
                captionText: "TextField2",
                onTextChange: onText2Change
            ).padding(20)
        }
    }
}
