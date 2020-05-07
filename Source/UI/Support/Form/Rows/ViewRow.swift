//
//  ViewRow.swift
//  iperf
//
//  Created by Deepu Mukundan on 5/6/20.
//

import Foundation

final class ViewRow: RowType {
    var childView: UIView

    init() {
        childView = UIView()
    }

    convenience init(_ initializer: (ViewRow) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        childView
    }
}
