//
//  FormViewController.swift
//  Form
//
//  Created by Deepu Mukundan on 2/27/20.
//  Copyright © 2020 Deepu Mukundan. All rights reserved.
//

import Foundation
import UIKit

public class FormViewController: UIViewController {
    public let form = Form()

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension FormViewController {
    func setup() {
        form.scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(form.scrollView)
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                form.scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                form.scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                form.scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                form.scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                form.scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                form.scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                form.scrollView.topAnchor.constraint(equalTo: view.topAnchor),
                form.scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            ])
        }

        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTap(tapGestureRecognizer:)))
        view.addGestureRecognizer(tap)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func backgroundTap(tapGestureRecognizer _: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            form.scrollView.contentInset = .zero
        } else {
            if #available(iOS 11.0, *) {
                form.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom + 12, right: 0)
            } else {
                form.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.bounds.height + 12, right: 0)
            }
        }

        form.scrollView.scrollIndicatorInsets = form.scrollView.contentInset
    }
}
