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

    func configure(with result: IPFTestResult) {
        resultsView.modeLabel.text = result.mode
        resultsView.dateLabel.text = IPFTestResultsCell.dateFormatter.string(from: result.date)
        resultsView.streamsLabel.text = String(result.streams)
        resultsView.durationLabel.text = "\(result.duration)s"
        resultsView.speedLabel.text = String(result.averageBandWidth)
        resultsView.locationLabel.text = result.location.isEmpty ? nil : result.location
    }

    private func setupUI() {
        resultsView.embed(in: self)
        resultsView.locationLabel.isHidden = false
        resultsView.modeLabel.font = .preferredFont(forTextStyle: .title2)
        resultsView.speedLabel.font = .preferredFont(forTextStyle: .title1)
    }

    private func reset() {
        resultsView.reset()
    }

    private lazy var resultsView: IPFTestResultsView = {
        return $0
    }(IPFTestResultsView())

    private static let dateFormatter: DateFormatter = {
        $0.dateStyle = .short
        $0.timeStyle = .short
        return $0
    }(DateFormatter())
}
