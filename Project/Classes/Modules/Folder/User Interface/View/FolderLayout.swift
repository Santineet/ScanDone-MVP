
import UIKit
import CHTCollectionViewWaterfallLayout

class FolderLayout: CHTCollectionViewWaterfallLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        columnCount = 3
        minimumInteritemSpacing = 10.0
        minimumColumnSpacing = 10.0
        sectionInset = UIEdgeInsets(top: 20.0, left: 20, bottom: 20, right: 20)
    }
    
}
