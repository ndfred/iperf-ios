//
//  SwitchRow.swift
//  Form
//
//  Created by Deepu Mukundan on 5/2/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

final class SwitchRow: RowType {
    var text: String
    var font: UIFont
    var state: Bool

    init() {
        text = ""
        font = .preferredFont(forTextStyle: .callout)
        state = false
    }

    convenience init(_ initializer: (SwitchRow) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
 
        toggleSwitch.isOn = state

        let hStack = UIStackView(arrangedSubviews: [label, UIView(), toggleSwitch])
        hStack.axis = .horizontal
        hStack.spacing = 8

        return hStack
    }

    func onToggle(_ action: @escaping (Bool) -> Void) -> RowType {
        actionWrapper = SwitchActionWrapper(from: action)
        toggleSwitch.addTarget(actionWrapper, action: #selector(actionWrapper.action(_:)), for: .valueChanged)
        return self
    }

    private let toggleSwitch = UISwitch()
    private var actionWrapper = SwitchActionWrapper(from: { _ in })
}

private final class SwitchActionWrapper: NSObject {
    private let _action: (Bool) -> Void

    init(from action: @escaping (Bool) -> Void) {
        _action = action
        super.init()
    }

    @objc func action(_ toggleSwitch: UISwitch) {
        _action(toggleSwitch.isOn)
    }
}
