//
//  IPFTestResult.swift
//  iperf
//
//  Created by Deepu Mukundan on 4/25/20.
//

import Foundation

@objcMembers
final class IPFTestResult: NSObject {
    var date: Date
    var mode: String
    var duration: UInt
    var streams: UInt
    var speed: String
    var location: String

    override init() {
        date = .distantPast
        mode = ""
        duration = 0
        streams = 0
        speed = ""
        location = ""
        super.init()
    }
}
