//
//  IPFTestResultsView.swift
//  iperf
//
//  Created by Deepu Mukundan on 5/6/20.
//

import Foundation

final class IPFTestResultsView: UIView {
    var currentBandWidth: Int = 0 {
        didSet {
            resultCount += 1
            averageBandwidthTotal += currentBandWidth
            averageBandWidth = averageBandwidthTotal / resultCount
            minBandWidth = min(minBandWidth, averageBandWidth)
            maxBandWidth = max(maxBandWidth, averageBandWidth)

            speedLabel.text = "\(currentBandWidth) Mbits/s"
            statsLabel.text = "Min: \(minBandWidth)\tAvg: \(averageBandWidth)\tMax: \(maxBandWidth)"
        }
    }

    private(set) var averageBandWidth: Int = 0
    private(set) var minBandWidth: Int = Int.max
    private(set) var maxBandWidth: Int = Int.min

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func showFinal() {
        speedLabel.text = "Average:\n\(averageBandWidth) Mbits/s"
        statsLabel.text = "Min: \(minBandWidth)\tMax: \(maxBandWidth)"
    }

    func reset() {
        currentBandWidth = 0
        resultCount = 0
        averageBandwidthTotal = 0
        averageBandWidth = 0
        minBandWidth = Int.max
        maxBandWidth = Int.min
        speedLabel.text = ""
        statsLabel.text = ""
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [speedLabel, statsLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        if #available(iOS 13.0, *) {
            backgroundColor = .systemGray5
        } else {
            // Fallback on earlier versions
        }
        stack.embed(in: self, insets: .default)
        layer.cornerRadius = 10
    }

    private lazy var speedLabel: UILabel = {
        $0.font = .boldSystemFont(ofSize: 40)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var statsLabel: UILabel = {
        $0.font = .systemFont(ofSize: 18)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private var averageBandwidthTotal: Int = 0
    private var resultCount = 0
}
