//
//  RowType.swift
//  Form
//
//  Created by Deepu Mukundan on 2/27/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

protocol RowType {
    init(_ initializer: (Self) -> Void)
    var view: UIView { get }
    var isHidden: Bool { get set }
}

extension RowType {
    var isHidden: Bool {
        get { view.isHidden }
        set { view.isHidden = newValue }
    }
}
