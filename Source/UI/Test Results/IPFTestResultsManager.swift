import Foundation

@objcMembers
final class IPFTestResultsManager: NSObject {
    static let shared = IPFTestResultsManager()

    var results = [IPFTestResult]()

    func add(_ result: IPFTestResult) {
        results.insert(result, at: 0)
    }
}
