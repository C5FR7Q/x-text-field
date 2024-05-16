//
//  FocusHolderView.swift
//  x-text-field
//
//  Created by Слава on 16.05.2024.
//

import SwiftUI

struct FocusHolderView<Content: View, FSValue: Hashable>: View {
    
    @FocusState
    var focusValue: FSValue?
    
    var content: (FocusState<FSValue?>.Binding) -> Content
    
    var body: some View {
        content($focusValue)
    }
}
