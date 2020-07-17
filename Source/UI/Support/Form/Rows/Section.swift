import Foundation
import UIKit

final class Section: RowType {
    var text: String

    init() {
        text = ""
    }

    convenience init(_ initializer: (Section) -> Void) {
        self.init()
        initializer(self)
    }

    var view: UIView {
        let container = UIView()
        if #available(iOS 13.0, *) {
            container.backgroundColor = .systemGray5
        } else {
            container.backgroundColor = .lightGray
        }

        let label = UILabel()
        label.text = text
        label.font = .preferredFont(forTextStyle: .title2)
        label.embed(in: container, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: -16))

        return container
    }
}

