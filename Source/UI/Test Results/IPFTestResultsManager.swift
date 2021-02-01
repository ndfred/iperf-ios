import Foundation

protocol IPFTestResultsDataStoreType {
    var results: [IPFTestResult] { get }
    func add(_ result: IPFTestResult)
}

final class IPFTestResultsStore: NSObject, IPFTestResultsDataStoreType {
    static let shared = IPFTestResultsStore()

    // MARK: - Lifecycle

    private override init() {

    }

    deinit {

    }

    // MARK: - Public Methods

    var results = [IPFTestResult]()

    func add(_ result: IPFTestResult) {
        results.insert(result, at: 0)
    }

    // MARK: - Private

    private let resultsStoreFile: URL? = {
        guard let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let file = docsDir.appendingPathComponent("IPFTestResults.json")
        return file
    }()
}
