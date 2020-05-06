//
//  IPFTestRunnerViewControllerV2.swift
//  iperf
//
//  Created by Deepu Mukundan on 5/5/20.
//

import UIKit
import AudioToolbox

final class IPFTestRunnerViewControllerV2: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        restoreTestSettings()
        setupUI()
    }

    private var configuration = IPFTestRunnerConfiguration()
    private var testRunner: IPFTestRunner?
    private var testLocation = ""
    private let durations: [UInt] = [5, 10, 30, 300]
    private var speedTestActiveTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
}

private extension IPFTestRunnerViewControllerV2 {

    // MARK: - User Actions

    @objc func showHelp() {
        show(IPFHelpViewController(), sender: self)
    }

    @objc func startStopTest() {
        if testRunner != nil {
            testRunner?.stopTest()
        } else {
            startTest()
        }
    }

    // MARK: - Other Private methods

    private func setupUI() {
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
        }
        title = NSLocalizedString("TestRunner.title", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("TestRunner.Help", comment: ""),
                                                           style: .plain,
                                                           target: self, action: #selector(showHelp))
        showStartButton()

        form
            +++ Section { _ in }
            +++ TextFieldRow {
                $0.placeHolder = "Server Address"
                $0.keyboardType = .numbersAndPunctuation
                $0.text = configuration.hostname
            }.onTextChange { [weak self] text in
                self?.configuration.hostname = text
            }
            +++ TextFieldRow {
                $0.placeHolder = "Server Port"
                $0.keyboardType = .numberPad
                $0.text = String(configuration.port)
            }.onTextChange { [weak self]  text in
                self?.configuration.port = UInt(text) ?? 0
            }
            +++ TextFieldRow {
                $0.placeHolder = "Test Location (Kitchen, Bedroom etc)"
                $0.keyboardType = .default
            }.onTextChange { [weak self]  text in
                self?.testLocation = text
            }

            +++ Section { _ in }
            +++ SegmentedRow {
                $0.text = "Transmit Mode"
                $0.segments = ["Upload", "Download"]
                $0.defaultSegment = Int(configuration.type.rawValue)
            }.onSegmentChange { [weak self] selectedIndex, _ in
                self?.configuration.type = IPFTestRunnerConfigurationType(rawValue: UInt(selectedIndex)) ?? .upload
            }
            +++ SegmentedRow {
                $0.text = "Streams"
                $0.segments = (1 ... 5).compactMap { String($0) }
                $0.defaultSegment = Int(configuration.streams) - 1
            }.onSegmentChange { [weak self] selectedIndex, _ in
                self?.configuration.streams = UInt(selectedIndex) + 1
            }
            +++ SegmentedRow {
                $0.text = "Test Duration"
                $0.segments = durations.compactMap { seconds -> String in
                    seconds < 60 ? "\(seconds)s" : "\(seconds / 60) min"
                }
                $0.defaultSegment = durations.firstIndex(of: configuration.duration) ?? 3
            }.onSegmentChange { [weak self] selectedIndex, _ in
                self?.configuration.duration = self?.durations[selectedIndex] ?? 10
            }
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
        testResult.speed = ""
        testResult.location = testLocation
        IPFTestResultsManager.shared.add(testResult)

        playFeedBack()
    }

    func playFeedBack() {
        AudioServicesPlayAlertSound(1109)

        if #available(iOS 10.0, *) {
            let feedbackGenerator = UINotificationFeedbackGenerator()
            feedbackGenerator.notificationOccurred(.success)
        } else {
            // Fallback on earlier versions
        }
    }

    func showStartButton(_ show: Bool = true) {
        let title = show ? "TestRunner.start" : "TestRunner.stop"
        let rightButton = UIBarButtonItem(title: NSLocalizedString(title, comment: ""),
                                                            style: .plain,
                                                            target: self, action: #selector(startStopTest))
        if !show {
            rightButton.tintColor = .red
        }

        navigationItem.rightBarButtonItem = rightButton
    }

    func startTest() {
        view.endEditing(true)
        self.showStartButton(false)

        let app = UIApplication.shared
        app.isNetworkActivityIndicatorVisible = true

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
                self.showAlert(message: NSLocalizedString("TestRunner.errorInitializing", comment: ""))
            case .cannotConnectToTheServer:
                self.showAlert(message: NSLocalizedString("TestRunner.connectionError", comment: ""))
            case .serverIsBusy:
                self.showAlert(message: NSLocalizedString("TestRunner.serverBusy", comment: ""))
            case .unknown:
                self.showAlert(message: NSLocalizedString("TestRunner.errorUnknown", comment: ""))
            @unknown default:
                self.showAlert(message: NSLocalizedString("TestRunner.errorUnknown", comment: ""))
            }

            if status.running.boolValue == false {
                self.form.enabled = true
                self.showStartButton()
                app.isNetworkActivityIndicatorVisible = false
                app.endBackgroundTask(self.speedTestActiveTaskIdentifier)
                self.testRunner = nil
                if status.errorState == .noError {
                    self.saveTestResults()
                    self.saveTestSettings()
                }
            } else {
                self.form.enabled = false
                self.showStartButton(false)
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alert, sender: self)
    }
    
}
