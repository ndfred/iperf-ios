import Foundation

struct IPFTestResult: Codable {
    var date: Date
    var mode: String
    var duration: UInt
    var streams: UInt
    var averageBandWidth: Int
    var location: String
}
