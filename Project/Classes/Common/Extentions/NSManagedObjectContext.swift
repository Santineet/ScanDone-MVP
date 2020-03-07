//
//  NSManagedObject.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 8/25/17.
//  Copyright © 2017 IgorBizi@mail.ru. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObjectContext {
    static func save() {
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
}
