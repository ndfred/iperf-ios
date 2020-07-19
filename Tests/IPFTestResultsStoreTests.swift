import XCTest
@testable import iperf

final class IPFTestResultsStoreTests: XCTestCase {

    let store = IPFTestResultsStore(storeFile: "Test")

    override func setUp() {
        super.setUp()
        store.clear()
    }

    override class func tearDown() {
        super.tearDown()
    }

    func testDatabaseReadWrite() {
        let result1 = IPFTestResult(date: Date(), mode: "Upload", duration: 10, streams: 5, averageBandWidth: 200, location: "Kitchen")
        let result2 = IPFTestResult(date: Date(), mode: "Download", duration: 5, streams: 1, averageBandWidth: 300, location: "Living Room")
        let result3 = IPFTestResult(date: Date(), mode: "Download", duration: 30, streams: 4, averageBandWidth: 250, location: "")

        store.add(result1)
        store.add(result2)
        store.add(result3)
        store.save()

        // Last entry added should be the first one to be retrieved
        XCTAssertEqual(store.results.first, result3)
        // First result added should be the last to be retrieved
        XCTAssertEqual(store.results.last, result1)
    }

    func testLargeDataSetSave() {
        insertLargeDataSet()

        measure {
            store.save()
        }
    }

    func testLargeDataSetRead() {
        insertLargeDataSet()
        store.save()

        measure {
            store.load()
        }
    }

}

private extension IPFTestResultsStoreTests {

    func insertLargeDataSet() {
        // Generate a large number of results and add into the store
        (1...10000).forEach { _ in
            let randomResult = IPFTestResult(date: Date(),
                                             mode: "Upload",
                                             duration: (1...30).randomElement() ?? 10,
                                             streams: (1...5).randomElement() ?? 5,
                                             averageBandWidth: (1...1024).randomElement() ?? 200,
                                             location: "Home")
            store.add(randomResult)
        }
    }

}
