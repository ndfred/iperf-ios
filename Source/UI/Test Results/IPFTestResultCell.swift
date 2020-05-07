//
//  IPFTestResultCell.swift
//  iperf
//
//  Created by Deepu Mukundan on 4/25/20.
//

import Foundation
import UIKit

final class IPFTestResultsCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)

    private lazy var modeLabel: UILabel = {
        $0.font = .systemFont(ofSize: 24)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var dateLabel: UILabel = {
        $0.font = .systemFont(ofSize: 9)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var durationLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var streamsLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var locationLabel: UILabel = {
        $0.font = .systemFont(ofSize: 12, weight: .light)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var speedLabel: UILabel = {
        $0.font = .systemFont(ofSize: 20, weight: .bold)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    func configure(with result: IPFTestResult) {
        modeLabel.text = result.mode
        dateLabel.text = IPFTestResultsCell.dateFormatter.string(from: result.date)
        streamsLabel.text = String(result.streams)
        durationLabel.text = "\(result.duration)s"
        speedLabel.text = String(result.averageBandWidth)
        locationLabel.text = result.location
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    override func prepareForReuse() {
        reset()
    }

    private func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [speedLabel, locationLabel])
        hStack.axis = .vertical
        hStack.spacing = 2
        let vStack = UIStackView(arrangedSubviews: [modeLabel, dateLabel, durationLabel, streamsLabel, hStack])
        vStack.axis = .horizontal
        vStack.spacing = 12
        vStack.embed(in: self, insets: .default)
        backgroundColor = .clear

        NSLayoutConstraint.activate([
            modeLabel.widthAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 54),
            durationLabel.widthAnchor.constraint(equalToConstant: 52),
            streamsLabel.widthAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func reset() {
        [modeLabel, dateLabel, streamsLabel, durationLabel, locationLabel, speedLabel].forEach { $0.text = nil }
    }

    private static let dateFormatter: DateFormatter = {
        $0.dateFormat = "MM/dd/YYYY\nhh:mm a"
        return $0
    }(DateFormatter())
}
