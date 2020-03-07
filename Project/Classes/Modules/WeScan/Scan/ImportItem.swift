//
//  ImportItem.swift
//  Project
//
//  Created by Igor Bizi, laptop2 on 09/08/2019.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

class ImportItem: NSObject {
    var original: UIImage
    var edited: UIImage?

    var display: UIImage {
        return edited ?? original
    }
    
    init(_ original: UIImage) {
        self.original = original
    }
    
    var filter = FilterItem.original
    var angle = 0
    var originalQuad: Quadrilateral?
    var quad: Quadrilateral?

    var item: FileItem?
    
    static func createFrom(_ i: FileItem) -> ImportItem? {
        guard let edited = UIImage(url: i.filePath(.edited).url), let original = UIImage(url: i.filePath(.original).url) else { return nil }
        let item = ImportItem(original)
        item.edited = edited
        item.filter = i.filter
        item.angle = i.angle
        item.quad = i.quad
        item.item = i
        item.originalQuad = i.originalQuad
        return item
    }
}
