import AudioToolbox
import UIKit

private enum IPFTestState {
    case active
    case inactive
}

final class IPFTestRunnerViewController: FormViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        restoreTestSettings()
        setupUI()
        updateUI(state: .inactive)
    }

    private var configuration = IPFTestRunnerConfiguration()
    private var testRunner: IPFTestRunner?
    private var testLocation = ""
    private let durations: [UInt] = [5, 10, 30, 300]
    private var resultsHeader = IPFTestResultsHeaderView()
    private lazy var progressView = UIProgressView(progressViewStyle: .bar)
    private var speedTestActiveTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
}

private extension IPFTestRunnerViewController {
    // MARK: - User Actions

    @objc func showHelp() {
        show(IPFHelpViewController(), sender: self)
    }

    @objc func startStopTest() {
        if configuration.hostname.isEmpty || !(0...65535).contains(configuration.port) {
            showAlert(message: "TestRunner.errorEmptyFields".localized)
            return
        }

        if testRunner != nil {
            testRunner?.stopTest()
        } else {
            resultsHeader.showInitial()
            startTest()
        }
    }

    // MARK: - Other Private methods

    func setupUI() {
        title = "TestRunner.title".localized

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TestRunner.Help".localized,
                                                           style: .plain,
                                                           target: self, action: #selector(showHelp))

        if let navBar = navigationController?.navigationBar {
            navigationController?.navigationBar.addSubview(progressView)
            progressView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                progressView.leftAnchor.constraint(equalTo: navBar.leftAnchor),
                progressView.rightAnchor.constraint(equalTo: navBar.rightAnchor),
                progressView.bottomAnchor.constraint(equalTo: navBar.bottomAnchor),
            ])
        }

        // Setup the individual UI fields

        form.addSection(Section())

        let header = ViewRow {
            $0.childView = resultsHeader
        }
        form.addRow(header)

        let serverAddress = TextFieldRow {
            $0.placeHolder = "TestRunner.serverAddress".localized
            $0.keyboardType = .numbersAndPunctuation
            $0.text = configuration.hostname
        }.onTextChange { [weak self] text in
            self?.configuration.hostname = text
        }
        form.addRow(serverAddress)

        let serverPort = TextFieldRow {
            $0.placeHolder = "TestRunner.serverPort".localized
            $0.keyboardType = .numberPad
            $0.text = String(configuration.port)
        }.onTextChange { [weak self] text in
            self?.configuration.port = UInt(text) ?? 0
        }
        form.addRow(serverPort)

        let testLocation = TextFieldRow {
            $0.placeHolder = "TestRunner.testLocation".localized
            $0.keyboardType = .default
        }.onTextChange { [weak self] text in
            self?.testLocation = text
        }
        form.addRow(testLocation)

        form.addSection(Section())

        let transmitMode = SegmentedRow {
            $0.text = "TestRunner.transmitMode".localized
            $0.segments = ["Upload", "Download"]
            $0.defaultSegment = Int(configuration.type.rawValue)
        }.onSegmentChange { [weak self] selectedIndex, _ in
            self?.configuration.type = IPFTestRunnerConfigurationType(rawValue: UInt(selectedIndex)) ?? .upload
        }
        form.addRow(transmitMode)

        let streams = SegmentedRow {
            $0.text = "TestRunner.streams".localized
            $0.segments = (1 ... 5).compactMap { String($0) }
            $0.defaultSegment = Int(configuration.streams) - 1
        }.onSegmentChange { [weak self] selectedIndex, _ in
            self?.configuration.streams = UInt(selectedIndex) + 1
        }
        form.addRow(streams)

        let duration = SegmentedRow {
            $0.text = "TestRunner.duration".localized
            $0.segments = durations.compactMap { seconds -> String in
                seconds < 60 ? "\(seconds)s" : "\(seconds / 60) min"
            }
            $0.defaultSegment = durations.firstIndex(of: configuration.duration) ?? 3
        }.onSegmentChange { [weak self] selectedIndex, _ in
            self?.configuration.duration = self?.durations[selectedIndex] ?? 10
        }
        form.addRow(duration)
    }

    func restoreTestSettings() {
        configuration.hostname = UserDefaults.hostname
        configuration.port = UserDefaults.port
        configuration.type = IPFTestRunnerConfigurationType(rawValue: UserDefaults.configType) ?? .upload
        configuration.streams = UserDefaults.streams
        configuration.duration = UserDefaults.duration
    }

    func saveTestSettings() {
        UserDefaults.hostname = configuration.hostname
        UserDefaults.port = configuration.port
        UserDefaults.configType = configuration.type.rawValue
        UserDefaults.streams = configuration.streams
        UserDefaults.duration = configuration.duration
    }

    func saveTestResults() {
        let testResult = IPFTestResult()
        testResult.date = Date()
        testResult.mode = configuration.type == .download ? "⇊" : "⇈"
        testResult.duration = configuration.duration
        testResult.streams = configuration.streams
        testResult.averageBandWidth = resultsHeader.averageBandWidth
        testResult.location = testLocation
        IPFTestResultsManager.shared.add(testResult)
    }

    func playFeedBack() {
        if UserDefaults.enableSounds {
            // A nice sound effect built-in to iOS
            AudioServicesPlayAlertSound(1109)
        }

        if #available(iOS 10.0, *), UserDefaults.enableHaptics {
            // Play a success notification haptic
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        }
    }

    func updateUI(state: IPFTestState) {
        let actionTitle: String

        switch state {
        case .active:
            actionTitle = "TestRunner.stop"
            form.enabled = false
            progressView.progress = 0
            progressView.isHidden = false
            UIApplication.shared.isNetworkActivityIndicatorVisible = true

        case .inactive:
            actionTitle = "TestRunner.start"
            form.enabled = true
            progressView.progress = 0
            progressView.isHidden = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }

        view.endEditing(true)

        let rightButton = UIBarButtonItem(title: actionTitle.localized, style: .plain, target: self, action: #selector(startStopTest))
        if state == .active {
            rightButton.tintColor = .red
        }
        navigationItem.rightBarButtonItem = rightButton
    }

    func startTest() {
        updateUI(state: .active)

        let app = UIApplication.shared
        speedTestActiveTaskIdentifier = app.beginBackgroundTask(expirationHandler: { [weak self] in
            guard let self = self else { return }
            app.endBackgroundTask(self.speedTestActiveTaskIdentifier)
        })

        testRunner = IPFTestRunner(configuration: configuration)
        testRunner?.startTest { [weak self] status in
            guard let self = self else { return }

            switch status.errorState {
            case .noError:
                break
            case .couldntInitializeTest:
                self.showAlert(message: "TestRunner.errorInitializing".localized)
            case .cannotConnectToTheServer:
                self.showAlert(message: "TestRunner.errorConnection".localized)
            case .serverIsBusy:
                self.showAlert(message: "TestRunner.errorServerBusy".localized)
            case .unknown:
                self.showAlert(message: "TestRunner.errorUnknown".localizeWithFormat(arguments: status.errorState.rawValue))
            @unknown default:
                break
            }

            if status.running.boolValue == false {
                self.resultsHeader.showFinal()
                app.endBackgroundTask(self.speedTestActiveTaskIdentifier)
                self.updateUI(state: .inactive)
                self.testRunner = nil
                if status.errorState == .noError || status.errorState == .serverIsBusy {
                    if self.resultsHeader.averageBandWidth > 0 {
                        self.saveTestResults()
                        self.saveTestSettings()
                        self.playFeedBack()
                    }
                }
            } else {
                self.updateUI(state: .active)
                self.progressView.setProgress(Float(status.progress), animated: true)
                self.resultsHeader.currentBandWidth = Int(status.bandwidth)
            }
        }
    }

    func showAlert(message: String) {
        resultsHeader.reset()

        let alert = UIAlertController(title: "Warning".localized, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localized, style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
