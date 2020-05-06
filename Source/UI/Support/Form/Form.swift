//
//  Form.swift
//  Form
//
//  Created by Deepu Mukundan on 2/27/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

public final class Form {

    var enabled: Bool {
        set { stackView.isUserInteractionEnabled = newValue }
        get { stackView.isUserInteractionEnabled }
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
        var sectionHeight: CGFloat = 30
        if let lastSpacer = lhs.stackView.arrangedSubviews.last, lastSpacer is Spacer {
            // Remove the last spacer before adding the section
            lhs.stackView.removeArrangedSubview(lastSpacer)
        } else {
            // This is the first section. Make it smaller to match iOS convention
            sectionHeight = 15
        }

        let sectionBreak = SectionBreak()
        lhs.stackView.addArrangedSubview(sectionBreak)
        sectionBreak.heightAnchor.constraint(equalToConstant: sectionHeight).isActive = true
    } else {
        let container = UIView()
        rhs.view.embed(in: container, insets: .side16)
        lhs.stackView.addArrangedSubview(container)
        let spacerView = Spacer()
        lhs.stackView.addArrangedSubview(spacerView)
        spacerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lhs.rows.append(rhs)
    }

    return lhs
}

private final class Spacer: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let grayView = UIView()
        if #available(iOS 13.0, *) {
            grayView.backgroundColor = .systemGray6
        } else {
            // Fallback on earlier versions
        }
        grayView.embed(in: self, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 0))
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private final class SectionBreak: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemGray5
        } else {
            // Fallback on earlier versions
        }
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
