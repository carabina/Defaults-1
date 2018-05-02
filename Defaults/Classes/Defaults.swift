//
//  Defaults.swift
//  Defaults
//
//  Created by Oren F on 02/05/2018.
//

import Foundation

 struct Defaults<T> {
    private let userDefaults: UserDefaults
    let key: String
    
    func value() -> T? {
        return userDefaults.value(forKey: key) as? T
    }
    
    func value(defaultValue: T) -> T? {
        return value() ?? defaultValue
    }
    
    func value<U>(defaultValue: U, _ closure: ((T) -> U?)) -> U {
        guard let value = value(), let concrete = closure(value) else { return defaultValue }
        return concrete
    }
    
    func save(_ value: T?) {
        saveOfClear(value)
    }
    
    func clear() {
        userDefaults.removeObject(forKey: key)
    }
    
    fileprivate func saveOfClear(_ value: Any?) {
        if let value = value {
            userDefaults.set(value, forKey: key)
        } else {
            clear()
        }
        userDefaults.synchronize()
    }
}
