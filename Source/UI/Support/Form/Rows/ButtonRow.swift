//
//  ButtonRow.swift
//  Form
//
//  Created by Deepu Mukundan on 2/28/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

final class ButtonRow: NSObject, RowType {
    var text: String
    var font: UIFont
    var tintColor: UIColor
    var backgroundColor: UIColor

    override init() {
        text = ""
        font = .preferredFont(forTextStyle: .callout)
        tintColor = .systemBlue
        backgroundColor = .clear
    }

    convenience init(_ initializer: (ButtonRow) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = font
        button.setTitleColor(tintColor, for: .normal)
        if #available(iOS 13.0, *) {
            button.setTitleColor(.systemGray2, for: .highlighted)
        } else {
            button.setTitleColor(.lightGray, for: .highlighted)
        }
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = 5
        return button
    }

    func onClick(_ action: @escaping () -> Void) -> RowType {
        actionWrapper = ButtonActionWrapper(from: action)
        button.addTarget(actionWrapper, action: #selector(actionWrapper.action), for: .touchDown)
        return self
    }

    private let button = UIButton()
    private var actionWrapper = ButtonActionWrapper(from: {})
}

private final class ButtonActionWrapper: NSObject {
    private let _action: () -> Void

    init(from action: @escaping () -> Void) {
        _action = action
        super.init()
    }

    @objc func action() {
        _action()
    }
}
