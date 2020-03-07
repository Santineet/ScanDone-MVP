//
//  Set.swift
//  Meditation1
//
//  Created by IgorBizi@mail.ru on 1/21/17.
//  Copyright © 2017 BEST. All rights reserved.
//

import Foundation

extension Set {
    func randomElement() -> Element? {
        guard self.isEmpty == false else {
            return nil
        }
        let randomInt = Int(arc4random_uniform(UInt32(self.count)))
        let index = self.index(startIndex, offsetBy: randomInt)
        return count == 0 ? nil: self[index]
    }
}
