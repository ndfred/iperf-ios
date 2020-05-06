//
//  TextRow.swift
//  Form
//
//  Created by Deepu Mukundan on 2/27/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

final class TextRow: RowType {
    var text: String
    var alignment: NSTextAlignment
    var font: UIFont

    init() {
        text = ""
        alignment = .left
        font = .preferredFont(forTextStyle: .callout)
    }

    convenience init(_ initializer: (TextRow) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = text
        label.font = font
        label.textAlignment = alignment
        return label
    }
}
