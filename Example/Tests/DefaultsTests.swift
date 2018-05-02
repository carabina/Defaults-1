//
//  DefaultsTests.swift
//  Defaults_Tests
//
//  Created by Oren F on 02/05/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import Defaults

class DefaultsTests: XCTestCase {
    
    func test_failLoadValue() {
        let def = Defaults<String>(key: "key")
        XCTAssertNil(def.value())
    }
    
    func test_successLoadClearValue() {
        let def = Defaults<String>(key: "key")
        def.save("Some value")
        XCTAssertNotNil(def.value())
        XCTAssertEqual(def.value(), "Some value")
        def.delete()
        XCTAssertNil(def.value())
    }
    
    func test_codableSuccessSaveLoadValue() {
        let object = Object.test()
        let def = Defaults<Object>(key: "object")
        XCTAssertNil(def.decodedValue())
        try? def.saveEncodeValue(object)
        
        let loaded = def.decodedValue()
        XCTAssertNotNil(loaded)
    
        XCTAssertEqual(object, loaded)
        def.delete()
        XCTAssertNil(def.decodedValue())
    }
    
    func test_defaultValue() {
        let def = Defaults<State>(key: "state")
        let value = def.value(defaultValue: .idle)
        XCTAssertEqual(value, .idle)
    }
    
    func test_convertValueUseExising() {
        let def = Defaults<Int>(key: "raw.state")
        def.save(0)
        let value: State = def.value(defaultValue: .normal, { State(rawValue: $0) })
        XCTAssertEqual(value, .idle)
        def.delete()
    }
    
    func test_convertValueUseDefault() {
        let def = Defaults<Int>(key: "raw.state")
        def.save(5)
        let value: State = def.value(defaultValue: .normal, { State(rawValue: $0) })
        XCTAssertEqual(value, .normal)
        def.delete()
    }
    
    func test_loadAndClearAllEntries() {
        let def = Defaults<Any>(defaults: UserDefaults())
        def.save("value 1", for: "1")
        def.save("value 2", for: "2")
        def.save("value 3", for: "3")
        def.save(4, for: "4")
        
        let all = def.allEntries()
        XCTAssert(all.contains(where: { $0.key == "1" }))
        XCTAssert(all.contains(where: { $0.key == "2" }))
        XCTAssert(all.contains(where: { $0.key == "3" }))
        XCTAssert(all.contains(where: { $0.key == "4" }))
        
        def.deleteAll(containedIn: ["1", "2", "3", "4"])
        let newAll = def.allEntries(containedIn: ["1", "2", "3", "4"])
        XCTAssertEqual(newAll.count, 0)
    }
}

private struct Object: Codable, Equatable {
    static func == (lhs: Object, rhs: Object) -> Bool {
        return lhs.value == rhs.value &&
               lhs.ref.value == rhs.ref.value
    }
    
    let value: String
    let ref: Ref
    
    static func test() -> Object {
        return Object(value: "Some value",
                      ref: Ref(value: 1)
        )
    }
}

private struct Ref: Codable {
    let value: Int
}

private enum State: Int {
    case idle
    case normal
    case failure
}
