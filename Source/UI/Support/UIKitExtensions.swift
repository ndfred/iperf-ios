//
//  UIKitExtensions.swift
//  iperf
//
//  Created by Deepu Mukundan on 4/25/20.
//

import UIKit

extension UIView {

    public func embed(in view: UIView, insets: UIEdgeInsets = .zero) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets.left),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -insets.right),
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -insets.bottom)
        ])
    }

}

extension UIEdgeInsets {

    public static var `default`: UIEdgeInsets {
        UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }

}
