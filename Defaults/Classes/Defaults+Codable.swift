//
//  Defaults+Codable.swift
//  Defaults
//
//  Created by Oren F on 02/05/2018.
//

import Foundation

public extension Defaults where T: Encodable {
    
    /// Saves `Encodable` by converting to `Data`
    ///
    /// - Parameters:
    ///   - value: `Encodable` object to save
    ///   - encoder: `JSONEncoder` to use for encoding. Defaults to `JSONEncoder()`
    /// - Throws: `Encoding` exception
    func saveEncodableValue(_ value: T, with encoder: JSONEncoder = JSONEncoder()) throws {
        do {
            saveOfClear(try encoder.encode(value), for: key)
        } catch {
            errorLog(error, "encode")
            throw error
        }
    }
}

public extension Defaults where T: Decodable {
    
    private func dataValue() -> Data? {
        return value(for: key) as? Data
    }
    
    /// Loads `Decodable` by loading `Data` and converting to expected type
    ///
    /// - Parameter decoder: A `JSONDecoder` to user for decoding. Defaults to `JSONDecoder()`
    /// - Returns: An optional value, if data exists and successfully converted.
    func decodableValue(with decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = dataValue() else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            errorLog(error, "decode")
            return nil
        }
    }
    
    /// Loads `Decodable` if exists
    ///
    /// - Parameter defaultValue: A value to return in case loading fails
    /// - Returns: Loaded value or `defaultValue` if doesn't exist
    func decodableValue(defaultValue: T) -> T {
        return decodableValue() ?? defaultValue
    }
}


internal extension Defaults {
    
    func errorLog(function: String = #function, line: Int = #line, _ error: Error, _ verb: String) {
        let template = """
        Defaults failed to \(verb) value for \(T.self)
        `Defaults.swift` \(function) : \(line)
        Error: \(error)
        """
        debugPrint(template)
    }
}
