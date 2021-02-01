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
