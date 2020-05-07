//
//  IPFSettingsViewController.swift
//  iperf
//
//  Created by Deepu Mukundan on 5/6/20.
//

import UIKit

final class IPFSettingsViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        title = "Settings.title".localized

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }

        form
            +++ Section { _ in }
            +++ SwitchRow {
                $0.text = "Settings.enableHaptics".localized
                $0.state = UserDefaults.enableHaptics
            }.onToggle { state in
                UserDefaults.enableHaptics = state
            }
            +++ SwitchRow {
                $0.text = "Settings.enableSounds".localized
                $0.state = UserDefaults.enableSounds
            }.onToggle { state in
                UserDefaults.enableSounds = state
            }
    }
}
