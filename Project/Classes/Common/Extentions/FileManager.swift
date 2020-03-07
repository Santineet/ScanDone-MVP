//
//  d.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 03/01/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

extension FileManager {
    func clearTmpDirectory() {
        do {
            let tmpDirURL = URL(string: NSTemporaryDirectory())!
            let tmpDirectory = try contentsOfDirectory(atPath: tmpDirURL.path)
            try tmpDirectory.forEach { file in
                let fileUrl = tmpDirURL.appendingPathComponent(file)
                try removeItem(atPath: fileUrl.path)
            }
        } catch let error as NSError {
            print("ERROR clearTmpDirectory: \(error)")
        }
    }
}
