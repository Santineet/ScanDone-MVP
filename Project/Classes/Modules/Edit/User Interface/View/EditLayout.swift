
import UIKit


class EditLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        scrollDirection = .horizontal
        sectionInset = UIEdgeInsets(top: 30, left: 20, bottom: 80, right: 20)
        let inset: CGFloat = 2
        minimumInteritemSpacing = inset
        minimumLineSpacing = inset
    }
    
    override func prepare() {
        super.prepare()
        
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
