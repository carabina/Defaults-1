//
//  Defaults.swift
//  Defaults
//
//  Created by Oren F on 02/05/2018.
//

import Foundation

/// A struct representing an entry in UserDefaults
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

/// A generic wrapper for UserDefaults
public struct Defaults<T> {
    internal let userDefaults: UserDefaults
    public let key: String
}

// MARK: Initialisers
public extension Defaults {
    
    /// Initialises a `Defaults` instance with `UserDefaults.standard` and a random, unique key
    init() {
        userDefaults = UserDefaults.standard
        key = UUID().uuidString
    }
    /// Initialises a `Defaults` instance with `UserDefaults.standard`
    ///
    /// - Parameter key: A key referencing a single, specific value in `UserDefaults`
    init(key: String) {
        userDefaults = UserDefaults.standard
        self.key = key
    }
    
    /// Initialises a `Defaults` instance with a random, unique key
    ///
    /// - Parameter defaults: A UserDefaults instance
    init(defaults: UserDefaults) {
        userDefaults = defaults
        key = UUID().uuidString
    }
    
    /// Initialises a `Defaults` instance
    ///
    /// - Parameters:
    ///   - defaults: A UserDefaults instance
    ///   - key: A key referencing a single, specific value in `UserDefaults`
    init(defaults: UserDefaults, key: String) {
        userDefaults = defaults
        self.key = key
    }
}

public extension Defaults {
    
    /// - Returns: An optional value matching the key
    func value() -> T? {
        return value(for: key) as? T
    }
    
    /// - Parameter defaultValue: A value to return if stored value returns `nil`
    /// - Returns: A value loaded from `UserDefaults` or given defaultValue
    func value(defaultValue: T) -> T {
        return value() ?? defaultValue
    }
    
    /// - Parameters:
    ///   - defaultValue: A value to return if stored value returns `nil`
    ///   - closure: A closure to convert expected returned value to a different type
    /// - Returns: A converted value loaded from `UserDefaults` or given defaultValue
    func value<U>(defaultValue: U, _ closure: ((T) -> U?)) -> U {
        guard let value = value(), let concrete = closure(value) else { return defaultValue }
        return concrete
    }
    
    /// - Parameter value: The value to save, or `nil` to delete
    func save(_ value: T?) {
        save(value, for: key)
    }
    
    /// Deletes associated value
    func delete() {
        save(nil)
    }
}

public extension Defaults {
    
    /// - Parameter key: A key for reference
    /// - Returns: An optional value for given key
    public func value(for key: String) -> Any? {
        return userDefaults.value(forKey: key)
    }

    /// - Parameters:
    ///   - value: A value to save, `nil` to delete
    ///   - key: A key for reference
    public func save(_ value: T?, for key: String) {
        saveOfClear(value, for: key)
    }
}

public extension Defaults {
    
    /// - Returns: Array of `DefaultsEntry`, listing all key:value pairs in `UserDefaults`
    func allEntries() -> [DefaultsEntry] {
        return userDefaults.dictionaryRepresentation().map({
            DefaultsEntry(key: $0.key, value: $0.value)
        })
    }
    
    /// Loads all enties from `UserDefaults`
    ///
    /// - Parameter keys: Array of `String` keys to filter
    /// - Returns: Array of `DefaultsEntry`, listing all key:value pairs in `UserDefaults`, matching given array
    func allEntries(containedIn keys: [String]) -> [DefaultsEntry] {
        return allEntries().filter({ keys.contains($0.key) })
    }

    /// Deletes all entries from `UserDefaults`
    func deleteAll() {
        for entry in allEntries() {
            save(nil, for: entry.key)
        }
        sync()
    }
    
    /// Deletes all entries from `UserDefaults`
    ///
    /// - Parameter keys: Array of `String` keys to filter
    func deleteAll(containedIn keys: [String]) {
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
