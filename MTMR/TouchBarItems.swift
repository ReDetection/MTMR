//
//  TouchBarItems.swift
//  MTMR
//
//  Created by Anton Palgunov on 18/03/2018.
//  Copyright © 2018 Anton Palgunov. All rights reserved.
//

import Cocoa

extension NSTouchBarItem.Identifier {
    static let controlStripItem = NSTouchBarItem.Identifier("com.toxblh.mtmr.controlStrip")
}

class CustomButtonTouchBarItem: NSCustomTouchBarItem {
    let tapClosure: () -> ()
    private(set) var button: NSButton!

    init(identifier: NSTouchBarItem.Identifier, title: String, onTap callback: @escaping () -> (), image: NSImage? = nil) {
        self.tapClosure = callback
        super.init(identifier: identifier)
        if let image = image {
            button = NSButton(title: title, image: image, target: self, action: #selector(didTapped))
            button.bezelColor = .clear
        } else {
            button = NSButton(title: title, target: self, action: #selector(didTapped))
        }
        self.view = button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func didTapped() {
        self.tapClosure()
        let hf: HapticFeedback = HapticFeedback()
        hf.tap(strong: 6)
    }
}

