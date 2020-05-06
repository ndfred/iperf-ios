//
//  TextFieldRow.swift
//  Form
//
//  Created by Deepu Mukundan on 2/29/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

final class TextFieldRow: NSObject, RowType {
    var placeHolder: String
    var keyboardType: UIKeyboardType
    var font: UIFont
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }

    override init() {
        placeHolder = ""
        keyboardType = .default
        font = .preferredFont(forTextStyle: .callout)
    }

    convenience init(_ initializer: (TextFieldRow) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        textField.placeholder = placeHolder
        textField.keyboardType = keyboardType
        textField.font = font
        textField.autocapitalizationType = .words
        return textField
    }

    func onTextChange(_ action: @escaping (String) -> Void) -> RowType {
        actionWrapper = TextFieldActionWrapper(from: action)
        textField.addTarget(actionWrapper, action: #selector(actionWrapper.action(_:)), for: .editingChanged)
        return self
    }

    private let textField = UITextField()
    private var actionWrapper = TextFieldActionWrapper(from: { _ in })
}

private final class TextFieldActionWrapper: NSObject {
    private let _action: (String) -> Void

    init(from action: @escaping (String) -> Void) {
        _action = action
        super.init()
    }

    @objc func action(_ textField: UITextField) {
        _action(textField.text ?? "")
    }
}
