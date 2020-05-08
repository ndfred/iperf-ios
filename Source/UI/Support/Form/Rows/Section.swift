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
