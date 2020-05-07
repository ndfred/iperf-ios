//
//  SegmentedRow.swift
//  Form
//
//  Created by Deepu Mukundan on 5/2/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

final class SegmentedRow: RowType {
    var text: String
    var font: UIFont
    var segments: [String]
    var defaultSegment: Int

    init() {
        text = ""
        font = .preferredFont(forTextStyle: .callout)
        segments = []
        defaultSegment = 0
    }

    convenience init(_ initializer: (SegmentedRow) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font

        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segments.enumerated().forEach { index, text in
            segmentedControl.insertSegment(withTitle: text, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex = defaultSegment

        let stack = UIStackView(arrangedSubviews: [label, segmentedControl])
        stack.axis = .horizontal
        stack.spacing = 8
        label.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.3).isActive = true

        return stack
    }

    func onSegmentChange(_ action: @escaping (Int, String) -> Void) -> RowType {
        actionWrapper = SegmentedControlActionWrapper(from: action)
        segmentedControl.addTarget(actionWrapper, action: #selector(actionWrapper.action(_:)), for: .valueChanged)
        return self
    }

    private let segmentedControl = UISegmentedControl()
    private var actionWrapper = SegmentedControlActionWrapper(from: { _, _ in })
}

private final class SegmentedControlActionWrapper: NSObject {
    private let _action: (Int, String) -> Void

    init(from action: @escaping (Int, String) -> Void) {
        _action = action
        super.init()
    }

    @objc func action(_ segmentedControl: UISegmentedControl) {
        let selection = segmentedControl.selectedSegmentIndex
        _action(selection, segmentedControl.titleForSegment(at: selection) ?? "")
    }
}
