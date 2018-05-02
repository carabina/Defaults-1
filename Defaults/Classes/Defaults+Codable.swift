//
//  Defaults+Codable.swift
//  Defaults
//
//  Created by Oren F on 02/05/2018.
//

import Foundation

extension Defaults where T: Codable {
    private func dataValue() -> Data? {
        return userDefaults.value(forKey: key) as? Data
    }
    
    func decodedValue(with decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = dataValue() else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            errorLog(error, "decode")
            return nil
        }
    }
    
    func decodedValue(defaultValue: T) -> T {
        return decodedValue() ?? defaultValue
    }
    
    func saveEncodeValue(_ value: T, with encoder: JSONEncoder = JSONEncoder()) {
        do {
            saveOfClear(try encoder.encode(value))
        } catch {
            errorLog(error, "encode")
        }
    }
    
    private func errorLog(function: String = #function, line: Int = #line, _ error: Error, _ verb: String) {
        let template = """
        Defaults failed to \(verb) value for \(T.self)
        `Defaults.swift` \(function) : \(line)
        Error: \(error)
        """
        debugPrint(template)
    }
}

