import Foundation
import UIKit

protocol IPFTestResultsStoreType {
    var results: [IPFTestResult] { get }
    func add(_ result: IPFTestResult)
    func remove(at index: Int)
    func save()
}

final class IPFTestResultsStore: NSObject, IPFTestResultsStoreType {
    var results = [IPFTestResult]()

    override init() {
        super.init()
        loadData()
    }

    func add(_ result: IPFTestResult) {
        results.insert(result, at: 0)
        dataMutated = true
    }

    func remove(at index: Int) {
        results.remove(at: index)
        dataMutated = true
    }

    func save() {
        // Prevent invalid disk writes
        guard dataMutated else { return }

        let app = UIApplication.shared
        dataStoreSaveTaskIdentifier = app.beginBackgroundTask(expirationHandler: { [weak self] in
            guard let self = self else { return }
            app.endBackgroundTask(self.dataStoreSaveTaskIdentifier)
        })

        // Save data to disk
        let encoder = PropertyListEncoder()
        encoder.outputFormat = .xml
        let testResultsData = try? encoder.encode(results)
        if let data = testResultsData, let storeFileURL = resultsStoreFileURL {
            try? data.write(to: storeFileURL)
        }

        dataMutated = false
        // End the background task
        app.endBackgroundTask(dataStoreSaveTaskIdentifier)
    }

    // MARK: - Private

    func loadData() {
        guard let storeFileURL = resultsStoreFileURL, let data = try? Data(contentsOf: storeFileURL) else { return }
        let decoder = PropertyListDecoder()
        let savedResults = try? decoder.decode([IPFTestResult].self, from: data)
        results.append(contentsOf: savedResults ?? [])
    }

    private var dataStoreSaveTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private var dataMutated = false

    private let resultsStoreFileURL: URL? = {
        guard let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let file = docsDir.appendingPathComponent("IPFTestResults.plist")
        return file
    }()
}
