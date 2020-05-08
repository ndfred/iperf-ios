import Foundation

final class IPFTestResultsHeaderView: UIView {
    var currentBandWidth: Int = 0 {
        didSet {
            resultCount += 1
            averageBandwidthTotal += currentBandWidth
            averageBandWidth = averageBandwidthTotal / resultCount
            minBandWidth = min(minBandWidth, currentBandWidth)
            maxBandWidth = max(maxBandWidth, currentBandWidth)

            let current = "TestRunner.megabits".localizeWithFormat(arguments: currentBandWidth)
            speedLabel.text = current

            let minSpeed = "TestRunner.minSpeed".localizeWithFormat(arguments: minBandWidth)
            let avgSpeed = "TestRunner.avgSpeed".localizeWithFormat(arguments: averageBandWidth)
            let maxSpeed = "TestRunner.maxSpeed".localizeWithFormat(arguments: maxBandWidth)
            statsLabel.text = minSpeed + "\t" + avgSpeed + "\t" + maxSpeed
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

    func showInitial() {
        speedLabel.text = "..."
        statsLabel.text = " "
    }

    func showFinal() {
        let averageSpeed = "TestRunner.megabits".localizeWithFormat(arguments: averageBandWidth)
        speedLabel.text = averageSpeed

        let minSpeed = "TestRunner.minSpeed".localizeWithFormat(arguments: minBandWidth)
        let maxSpeed = "TestRunner.maxSpeed".localizeWithFormat(arguments: maxBandWidth)
        statsLabel.text = minSpeed + "\t" + maxSpeed
    }

    func reset() {
        currentBandWidth = 0
        resultCount = 0
        averageBandwidthTotal = 0
        averageBandWidth = 0
        minBandWidth = Int.max
        maxBandWidth = Int.min
        speedLabel.text = " "
        statsLabel.text = " "
    }

    private func setupUI() {
        let stack = UIStackView(arrangedSubviews: [speedLabel, statsLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = 8
        if #available(iOS 13.0, *) {
            backgroundColor = .systemGray5
        } else {
            backgroundColor = .lightGray
        }
        stack.embed(in: self, insets: .default)
        layer.cornerRadius = 10
    }

    private lazy var speedLabel: UILabel = {
        if #available(iOS 11.0, *) {
            $0.font = .preferredFont(forTextStyle: .largeTitle, compatibleWith: traitCollection)
        } else {
            $0.font = .boldSystemFont(ofSize: 40)
        }
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private lazy var statsLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .body)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        return $0
    }(UILabel())

    private var averageBandwidthTotal: Int = 0
    private var resultCount = 0
}
