import Foundation

@objcMembers
final class IPFTestResult: NSObject {
    var date: Date
    var mode: String
    var duration: UInt
    var streams: UInt
    var averageBandWidth: Int
    var location: String

    override init() {
        date = .distantPast
        mode = ""
        duration = 0
        streams = 0
        averageBandWidth = 0
        location = ""
        super.init()
    }
}
