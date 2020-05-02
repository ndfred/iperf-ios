//
//  IPFTestResultsHeaderView.swift
//  iperf
//
//  Created by Deepu Mukundan on 4/25/20.
//

import UIKit

final class IPFTestResultsHeaderView: UIView {
    private lazy var modeLabel: UILabel = {
        $0.text = NSLocalizedString("Mode", comment: "Speed Test Mode (Upload/Download)")
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var dateLabel: UILabel = {
        $0.text = "Date"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var durationLabel: UILabel = {
        $0.text = "Duration"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var streamsLabel: UILabel = {
        $0.text = "Streams"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .white
        return $0
    }(UILabel())

    private lazy var speedLabel: UILabel = {
        $0.text = "Speed\nMbits/s"
        $0.font = .boldSystemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        $0.textColor = .white
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        let vStack = UIStackView(arrangedSubviews: [modeLabel, dateLabel, durationLabel, streamsLabel, speedLabel])
        vStack.axis = .horizontal
        vStack.spacing = 12
        vStack.embed(in: self, insets: UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16))
        backgroundColor = .lightGray

        NSLayoutConstraint.activate([
            modeLabel.widthAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 54),
            durationLabel.widthAnchor.constraint(equalToConstant: 52),
            streamsLabel.widthAnchor.constraint(equalToConstant: 50),
        ])
    }
}
