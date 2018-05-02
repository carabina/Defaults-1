//
//  Defaults.swift
//  Defaults
//
//  Created by Oren F on 02/05/2018.
//

import Foundation

public struct Defaults<T> {
    
    internal let userDefaults: UserDefaults
    public let key: String
    
    public func value() -> T? {
        return userDefaults.value(forKey: key) as? T
    }
    
    public func value(defaultValue: T) -> T? {
        return value() ?? defaultValue
    }
    
    public func value<U>(defaultValue: U, _ closure: ((T) -> U?)) -> U {
        guard let value = value(), let concrete = closure(value) else { return defaultValue }
        return concrete
    }
    
    public func save(_ value: T?) {
        saveOfClear(value)
    }
    
    public func delete() {
        save(nil)
    }
    
    internal func saveOfClear(_ value: Any?) {
        if let value = value {
            userDefaults.set(value, forKey: key)
        } else {
            userDefaults.removeObject(forKey: key)
            userDefaults.set(nil, forKey: key)
        }
        sync()
    }
    
    private func sync() {
        userDefaults.synchronize()
    }
}

// MARK: Initialisers
public extension Defaults {
    
    init(key: String) {
        userDefaults = UserDefaults.standard
        self.key = key
    }
    
    init(defaults: UserDefaults, key: String) {
        userDefaults = defaults
        self.key = key
    }
}
