
import UIKit

class FilterMenuLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        minimumInteritemSpacing = 0.0
        minimumLineSpacing = 0.0
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: AppDependencies.appDelegate.window?.safeAreaInsets.bottom ?? 0, right: 10)


    }
    
}
