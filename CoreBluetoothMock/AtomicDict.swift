//
//  AtomicDict.swift
//
//
//  Created by Charysz, Wojciech on 11.03.24.
//

import Foundation

class AtomicDict<Key: Hashable, Value>: CustomDebugStringConvertible {
    private var dictStorage = [Key: Value]()
    private let queue = DispatchQueue(label: "CoreBluetoothMock.\(UUID().uuidString)", qos: .utility, attributes: .concurrent,
                                      autoreleaseFrequency: .inherit, target: .global())
    
    subscript(key: Key) -> Value? {
        get {
            queue.sync {
                dictStorage[key]
            }
        }
        set {
            queue.async(flags: .barrier) { [weak self] in
                self?.dictStorage[key] = newValue
            }
        }
    }
    
    var debugDescription: String {
        dictStorage.debugDescription
    }
    
    func filter(_ isIncluded: (Dictionary<Key, Value>.Element) throws -> Bool) rethrows -> [Key : Value] {
        try queue.sync {
            try dictStorage.filter(isIncluded)
        }
    }
}
