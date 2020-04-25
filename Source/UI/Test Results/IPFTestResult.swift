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
    var duration: NSInteger
    var streams: NSInteger
    var speed: String
    var location: String

    override init() {
        self.date = .distantPast
        self.mode = ""
        self.duration = 0
        self.streams = 0
        self.speed = ""
        self.location = ""
        super.init()
    }
}
