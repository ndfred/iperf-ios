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
        get { readValue(.hostname) ?? "" }
        set { storeValue(newValue, for: .hostname) }
    }

    static var port: UInt {
        get { readValue(.port) ?? 5201 }
        set { storeValue(newValue, for: .port) }
    }

    static var configType: UInt {
        get { readValue(.configType) ?? 1 }
        set { storeValue(newValue, for: .configType) }
    }

    static var streams: UInt {
        get { readValue(.streams) ?? 5 }
        set { storeValue(newValue, for: .streams) }
    }

    static var duration: UInt {
        get { readValue(.duration) ?? 10 }
        set { storeValue(newValue, for: .duration) }
    }

    static var enableHaptics: Bool {
        get { readValue(.enableHaptics) ?? true }
        set { storeValue(newValue, for: .enableHaptics) }
    }

    static var enableSounds: Bool {
        get { readValue(.enableSounds) ?? true }
        set { storeValue(newValue, for: .enableSounds) }
    }

    static func reset() {
        UserDefaultsKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
    }
}

private extension UserDefaults {
    static func readValue<U>(_ key: UserDefaultsKey) -> U? {
        UserDefaults.standard.value(forKey: key.rawValue) as? U
    }

    static func storeValue<U>(_ value: U, for key: UserDefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
}
