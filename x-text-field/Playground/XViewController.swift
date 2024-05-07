//
//  XViewController.swift
//  x-text-field
//
//  Created by Слава on 07.05.2024.
//

import SwiftUI

final class XViewController: UIHostingController<XScreen> {
    
    // MARK: Object lifecycle
    init() {
        super.init(
            rootView: XScreen()
        )
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
