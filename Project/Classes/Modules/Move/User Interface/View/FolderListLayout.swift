
import UIKit
import CHTCollectionViewWaterfallLayout

class FolderListLayout: CHTCollectionViewWaterfallLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        columnCount = 1
        minimumInteritemSpacing = 1.0
        minimumColumnSpacing = 1.0
        sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 0, right: 0)
    }
    
}
