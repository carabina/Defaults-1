//
//  Defaults.swift
//  Defaults
//
//  Created by Oren F on 02/05/2018.
//

import Foundation

public struct DefaultsEntry: CustomStringConvertible {
    public let key: String
    public let value: Any
    
    public var description: String {
        return """
        DefaultsEntry {
            "key" = \(key)
            "value" = \(value)
        }
        """
    }
}

public struct Defaults<T> {
    
    internal let userDefaults: UserDefaults
    public let key: String
    
}

// MARK: Initialisers
public extension Defaults {
    
    init(key: String) {
        userDefaults = UserDefaults.standard
        self.key = key
    }
    
    init(defaults: UserDefaults) {
        userDefaults = defaults
        key = UUID().uuidString
    }
    
    init(defaults: UserDefaults, key: String) {
        userDefaults = defaults
        self.key = key
    }
}

public extension Defaults {
    
    func value() -> T? {
        return value(for: key) as? T
    }
    
    func value(defaultValue: T) -> T? {
        return value() ?? defaultValue
    }
    
    func value<U>(defaultValue: U, _ closure: ((T) -> U?)) -> U {
        guard let value = value(), let concrete = closure(value) else { return defaultValue }
        return concrete
    }
    
    func save(_ value: T?) {
        save(value, for: key)
    }
    
    func delete() {
        save(nil)
    }
}

public extension Defaults {
    
    public func value(for key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }

    public func save(_ value: T?, for key: String) {
        saveOfClear(value, for: key)
    }
}

public extension Defaults {
    
    func allEntries() -> [DefaultsEntry] {
        return userDefaults.dictionaryRepresentation().map({
            DefaultsEntry(key: $0.key, value: $0.value)
        })
    }
    
    func allEntries(containedIn keys: [String]) -> [DefaultsEntry] {
        return allEntries().filter({ keys.contains($0.key) })
    }

    func clearAll() {
        for entry in allEntries() {
            save(nil, for: entry.key)
        }
        sync()
    }
    
    func clearAll(containedIn keys: [String]) {
        for entry in allEntries(containedIn: keys) {
            save(nil, for: entry.key)
        }
        sync()
    }
}

internal extension Defaults {
    
    func saveOfClear(_ value: Any?, for key: String) {
        if let value = value {
            userDefaults.set(value, forKey: key)
        } else {
            userDefaults.removeObject(forKey: key)
            userDefaults.set(nil, forKey: key)
        }
        sync()
    }
    
    func sync() {
        userDefaults.synchronize()
    }
}
