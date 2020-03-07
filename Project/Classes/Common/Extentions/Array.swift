//
//  Array.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 1/21/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element? {
        if let index = randomIndex() {
            return self[index]
        } else {
            return nil
        }
    }
    
    func randomIndex() -> Int? {
        guard self.isEmpty == false else {
            return nil
        }
        return Int(arc4random_uniform(UInt32(self.count)))//Int(rand()) % count
    }
    
    func chunks(_ chunkSize: Int) -> [[Element]] {
        return stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
    }
    
}

extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}

extension Array where Element: Equatable {
    mutating func remove(object: Element) {
        if let index = self.index(of: object) {
            remove(at: index)
        }
    }
    
    func take(_ elementsCount: Int) -> [Element] {
        let min = Swift.min(elementsCount, count)
        return Array(self[0..<min])
    }
}
