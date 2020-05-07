//
//  UserDefaultsExtension.swift
//  iperf
//
//  Created by Deepu Mukundan on 5/5/20.
//

import Foundation

private enum UserDefaultsKey: String, CaseIterable {
    case hostname = "IPFTestHostname"
    case port = "IPFTestPort"
    case configType
    case streams
    case duration
    case enableHaptics
    case enableSounds
}

public extension UserDefaults {
    static var hostname: String {
        get { return read(.hostname) ?? "" }
        set { store(newValue, for: .hostname) }
    }

    static var port: UInt {
        get { return read(.port) ?? 5201 }
        set { store(newValue, for: .port) }
    }

    static var configType: UInt {
        get { return read(.configType) ?? 1 }
        set { store(newValue, for: .configType) }
    }

    static var streams: UInt {
        get { return read(.streams) ?? 5 }
        set { store(newValue, for: .streams) }
    }

    static var duration: UInt {
        get { return read(.duration) ?? 10 }
        set { store(newValue, for: .duration) }
    }

    static var enableHaptics: Bool {
        get { return read(.enableHaptics) ?? true }
        set { store(newValue, for: .enableHaptics) }
    }

    static var enableSounds: Bool {
        get { return read(.enableSounds) ?? true }
        set { store(newValue, for: .enableSounds) }
    }

    static func reset() {
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}

private extension UserDefaults {
    static func read<U>(_ key: UserDefaultsKey) -> U? {
        return UserDefaults.standard.value(forKey: key.rawValue) as? U
    }

    static func store<U>(_ value: U, for key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
