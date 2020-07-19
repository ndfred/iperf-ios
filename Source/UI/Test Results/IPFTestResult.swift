import Foundation

struct IPFTestResult: Codable, Equatable {
    var date: Date
    var mode: String
    var duration: UInt
    var streams: UInt
    var averageBandWidth: Int
    var location: String
}
