import Foundation
import UIKit
import os

protocol IPFTestResultsStoreType {
    var results: [IPFTestResult] { get }
    func add(_ result: IPFTestResult)
    func remove(at index: Int)
    func save()
    func clear()
}

final class IPFTestResultsStore: NSObject, IPFTestResultsStoreType {
    var results = [IPFTestResult]()

    private override init() {
        super.init()
    }

    convenience init(storeFile: String = "IPFTestResults") {
        self.init()
        self.resultsStoreFile = storeFile
        load()
    }

    func add(_ result: IPFTestResult) {
        results.insert(result, at: 0)
        dataMutated = true
    }

    func remove(at index: Int) {
        results.remove(at: index)
        dataMutated = true
    }

    func clear() {
        results.removeAll()
        dataMutated = true
        save()
    }

    func save() {
        // Prevent unwanted disk writes
        guard dataMutated else { return }

        let app = UIApplication.shared
        dataStoreSaveTaskIdentifier = app.beginBackgroundTask(expirationHandler: { [weak self] in
            guard let self = self else { return }
            app.endBackgroundTask(self.dataStoreSaveTaskIdentifier)
        })

        // Encode and Save data to disk
        let encoder = JSONEncoder()
        let testResultsData = try? encoder.encode(results)
        if let data = testResultsData, let storeFileURL = resultsStoreFileURL {
            try? data.write(to: storeFileURL)
        }

        dataMutated = false
        // End the background task
        app.endBackgroundTask(dataStoreSaveTaskIdentifier)
    }

    func load() {
        guard let storeFileURL = resultsStoreFileURL, let data = try? Data(contentsOf: storeFileURL) else { return }
        if #available(iOS 10.0, *) {
            os_log("💾 Store File: %{public}s", log: .default, type: .info, storeFileURL.description)
        }
        let decoder = JSONDecoder()
        let savedResults = try? decoder.decode([IPFTestResult].self, from: data)
        results.append(contentsOf: savedResults ?? [])
    }

    // MARK: - Private

    private var resultsStoreFile = ""
    private var dataStoreSaveTaskIdentifier: UIBackgroundTaskIdentifier = .invalid
    private var dataMutated = false

    private lazy var resultsStoreFileURL: URL? = {
        guard let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let file = docsDir.appendingPathComponent(resultsStoreFile + ".json")
        return file
    }()
}
