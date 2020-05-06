//
//  SectionBreakRow.swift
//  Form
//
//  Created by Deepu Mukundan on 5/2/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

final class Section: RowType {
    init() {}

    convenience init(_ initializer: (Section) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        let view = UIView()
        return view
    }
}
