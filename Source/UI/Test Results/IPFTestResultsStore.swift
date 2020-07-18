import Foundation

protocol IPFTestResultsStoreType {
    var results: [IPFTestResult] { get }
    func add(_ result: IPFTestResult)
    func remove(at index: Int)
}

final class IPFTestResultsStore: NSObject, IPFTestResultsStoreType {
    var results = [IPFTestResult]()

    func add(_ result: IPFTestResult) {
        results.insert(result, at: 0)
    }

    func remove(at index: Int) {
        
    }

    // MARK: - Private

    private let resultsStoreFile: URL? = {
        guard let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        let file = docsDir.appendingPathComponent("IPFTestResults.json")
        return file
    }()
}
