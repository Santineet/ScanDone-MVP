//
//  PreviewProtocols.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


protocol PreviewDataManagerAPIInput: class {
    
}


protocol PreviewDataManagerLocalInput: class {
    
}


protocol PreviewInteractorInput: class {

}


protocol PreviewInteractorOutput: class {

}


protocol PreviewModuleInterface: class {
    var delegate: PreviewDelegate? {get set}

    func viewDidLoad()
    
    func didSelectShare()
    func didSelectEdit()
    func didSelectDelete()
    func didSelectMore()
}


protocol PreviewViewInterface: class {
    
}


protocol PreviewWireframeInput: class {
    
    
}


protocol PreviewDelegate: class {
    var item: FolderItem {get}
    func didSelectEdit(_ indexPath: IndexPath)
}

