import Foundation
import UIKit

public final class Form {
    var enabled: Bool {
        set { stackView.isUserInteractionEnabled = newValue }
        get { stackView.isUserInteractionEnabled }
    }

    func addSection(_ section: RowType) {
        var sectionHeight: CGFloat = 30
        if let lastSpacer = stackView.arrangedSubviews.last, lastSpacer is Spacer {
            // Remove the last spacer before adding the section
            stackView.removeArrangedSubview(lastSpacer)
        } else {
            // This is the first section. Make it smaller to match iOS convention
            sectionHeight = 8
        }

        let container = UIView()
        section.view.embed(in: container)
        stackView.addArrangedSubview(container)
        container.heightAnchor.constraint(equalToConstant: sectionHeight).isActive = true
    }

    func addRow(_ row: RowType) {
        let container = UIView()
        row.view.embed(in: container, insets: .side16)
        stackView.addArrangedSubview(container)
        let spacerView = Spacer()
        stackView.addArrangedSubview(spacerView)
        spacerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        rows.append(row)
    }

    lazy var stackView: UIStackView = {
        $0.axis = .vertical
        $0.spacing = 8
        return $0
    }(UIStackView())

    lazy var scrollView: UIScrollView = {
        $0.scrollsToTop = true
        stackView.embed(in: $0)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: $0.centerXAnchor),
        ])
        return $0
    }(UIScrollView())

    var rows = [RowType]()
}

// MARK: - Convenience row and section add methods

precedencegroup FormPrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
}

precedencegroup SectionPrecedence {
    associativity: left
    higherThan: FormPrecedence
}

infix operator +++: FormPrecedence

@discardableResult func +++ (lhs: Form, rhs: RowType) -> Form {
    if rhs is Section {
        lhs.addSection(rhs)
    } else {
        lhs.addRow(rhs)
    }

    return lhs
}

// MARK: - Private objects

private final class Spacer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let grayView = UIView()
        if #available(iOS 13.0, *) {
            grayView.backgroundColor = .systemGray6
        } else {
            grayView.backgroundColor = .lightGray
        }
        grayView.embed(in: self, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

