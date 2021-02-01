import UIKit

final class IPFTestResultsView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func reset() {
        [modeLabel, dateLabel, streamsLabel, durationLabel, locationLabel, speedLabel, locationLabel].forEach { $0.text = nil }
    }

    private func setupUI() {
        let hStack = UIStackView(arrangedSubviews: [speedLabel, locationLabel])
        hStack.axis = .vertical
        hStack.spacing = 2
        let vStack = UIStackView(arrangedSubviews: [modeLabel, dateLabel, durationLabel, streamsLabel, hStack])
        vStack.axis = .horizontal
        vStack.spacing = 12
        vStack.embed(in: self, insets: .default)

        NSLayoutConstraint.activate([
            modeLabel.widthAnchor.constraint(equalToConstant: 34),
            dateLabel.widthAnchor.constraint(equalToConstant: 54),
            durationLabel.widthAnchor.constraint(equalToConstant: 52),
            streamsLabel.widthAnchor.constraint(equalToConstant: 50),
        ])
    }

    lazy var modeLabel: UILabel = {
        $0.text = "TestResults.mode".localized
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        if #available(iOS 13.0, *) {
            $0.textColor = .label
        } else {
            $0.textColor = .black
        }
        return $0
    }(UILabel())

    lazy var dateLabel: UILabel = {
        $0.text = "TestResults.date".localized
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        if #available(iOS 13.0, *) {
            $0.textColor = .label
        } else {
            $0.textColor = .black
        }
        return $0
    }(UILabel())

    lazy var durationLabel: UILabel = {
        $0.text = "TestResults.duration".localized
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        if #available(iOS 13.0, *) {
            $0.textColor = .label
        } else {
            $0.textColor = .black
        }
        return $0
    }(UILabel())

    lazy var streamsLabel: UILabel = {
        $0.text = "TestResults.streams".localized
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        if #available(iOS 13.0, *) {
            $0.textColor = .label
        } else {
            $0.textColor = .black
        }
        return $0
    }(UILabel())

    lazy var speedLabel: UILabel = {
        $0.text = "TestResults.speed".localized
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        if #available(iOS 13.0, *) {
            $0.textColor = .label
        } else {
            $0.textColor = .black
        }
        return $0
    }(UILabel())

    lazy var locationLabel: UILabel = {
        $0.font = .preferredFont(forTextStyle: .caption1)
        $0.textAlignment = .center
        $0.numberOfLines = 0
        if #available(iOS 13.0, *) {
            $0.textColor = .label
        } else {
            $0.textColor = .black
        }
        return $0
    }(UILabel())
}
