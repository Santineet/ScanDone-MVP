//
//  EditPresenter.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class EditPresenter: RootPresenter {
    
    var wireframe: EditWireframe!
    weak var userInterface: EditViewController!
    var interactor: EditInteractorInput!
    
    deinit {
    }
    
    weak var delegate: EditDelegate?
    
    //for edit saved items
    var item: FolderItem?
    var type: EditPresenterType!
    
    var dataSource: [ImportItem] {
        get {
            if let delegate = delegate {
                return delegate.dataSource
            } else {
                return []
            }
        } set {
            if let _ = delegate {
                self.delegate?.dataSource = newValue
            }
        }
    }
}

extension EditPresenter: EditModuleInterface {
    
    func viewDidLoad() {
        
    }
    
    func didSelectDelete() {
        weak var weakSelf = self
        guard let indexPath = userInterface.visibleIndexPath() else { return }
        Alert.show(style: .actionSheet, okTitle: "Delete".localized.uppercased(), okButton: true, okStyle: .destructive, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), sourceView: userInterface.deleteButton, okEventHandler: { (_) in
            
            let index = indexPath.section
            guard var dataSource = weakSelf?.dataSource else { return }
            guard index >= 0, dataSource.count > 0, index < dataSource.count else { return }
            
            dataSource.remove(at: index)
            weakSelf?.dataSource = dataSource
            
            weakSelf?.userInterface.reloadData()
            delay(1, closure: {
                weakSelf?.userInterface.reloadNavigationTitleForVisibleItem()
                weakSelf?.userInterface.reloadFilterViewForVisibleItem()
            })
            
            if dataSource.count == 0 {
                weakSelf?.wireframe.dismissInterface()
            }
        })
    }
  
    func didSelectCrop() {
        guard let item = visibleItem else { return }
        guard let image = applyEdit(crop: false) else { return }
        wireframe.presentCropInterface(image, item.quad)
    }
    
    func didSelectFilter(_ filter: FilterItem, _ indexPath: IndexPath) {
        guard let item = visibleItem else { return }
        item.filter = filter
        edit()
    }
    
    func didSelectRotate() {
        guard let item = visibleItem else { return }
        
        let angle = -90
        item.angle += angle
        if Double(item.angle) / 360.0 > 1 {
            item.angle = item.angle % 360
        } else if item.angle % 360 == 0 {
            item.angle = 0
        }
        
        edit()
    }
    
    func didSelectAdd() {
        wireframe.dismissInterface()
    }
    
    func didSelectCancel() {
        func dismiss(confirmation: Bool) {
            func dismiss() {
                userInterface.navigationController?.dismiss(animated: true, completion: nil)
            }
            
            if confirmation {
                Alert.show(title: "Do you want to Close?".localized, okTitle: "Close".localized, okStyle: .destructive, cancelButton: true, okEventHandler: { (_) in
                    dismiss()
                })
            } else {
                dismiss()
            }
        }
        
        if let delegate = delegate {
            let value = delegate.dataSource.isEmpty
            dismiss(confirmation: !value)
        } else if let _ = item {
            dismiss(confirmation: true)
        }
    }
    
    func didSelectDone() {
        weak var weakSelf = self

        func finish(_ error: Error?) {
            userInterface.collectionView.showLoadingHud(false, onSuperview: true)
            UIView.animate(withDuration: 0.3, animations: {
                weakSelf?.userInterface.collectionView.alpha = 1
            })
            
            if let error = error {
                Alert.showError(error)
            } else {
                weakSelf?.userInterface.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        

        userInterface.collectionView.showLoadingHud(true, color: .white, onSuperview: true)
        UIView.animate(withDuration: 0.3, animations: {
            weakSelf?.userInterface.collectionView.alpha = 0.1
        }, completion: { (_) in
            if let type = weakSelf?.type {
                switch type {
                case .create, .append:
                    if let delegate = weakSelf?.delegate {
                        FolderItem.create(delegate.dataSource, delegate.item) { (error) in
                            finish(error)
                        }
                    }
                case .edit:
                    if let item = weakSelf?.item, let dataSource = weakSelf?.dataSource {
                        FolderItem.update(dataSource, item) { (error) in
                            finish(error)
                        }
                    }
                default: break
                }
            }
        })
    }
    
    func didSelectImageRecognizer() {
        guard let item = visibleItem else { return }
        wireframe.presentImageRecognizerInterface(item)
    }
}


extension EditPresenter: EditInteractorOutput {
    
}



//METHODS
extension EditPresenter {

    var visibleIndex: Int? {
        guard let indexPath = userInterface.visibleIndexPath() else { return nil }
        let index = indexPath.section
        guard index >= 0, dataSource.count > 0, index < dataSource.count else { return nil }
        return index
    }
    
    var visibleItem: ImportItem? {
        guard let index = visibleIndex else { return nil }
        guard index >= 0, dataSource.count > 0, index < dataSource.count else { return nil }
        return dataSource[index]
    }
    
    func edit() {
        guard let index = visibleIndex else { return }
        let edited = applyEdit()
        self.dataSource[index].edited = edited
        userInterface.reloadData()
    }
    
    func applyEdit(rotate: Bool = true, filter: Bool = true, crop: Bool = true) -> UIImage? {
        guard let item = visibleItem else { return nil }
        let original = item.original
        var edited = original
        
        if var quad = item.originalQuad {
            if crop, let image = edited.crop(quad: quad, quadViewSize: nil)?.image {
                edited = image
            }
            
            if item.angle != 0 {
                let originalSize = original.size
                let targetSize = item.angle % 180 != 0 ? originalSize.reverse : originalSize
                let targetAngle = CGFloat(item.angle) * .pi/180
                quad = quad.scale(originalSize, targetSize, withRotationAngle: targetAngle)
            }
            item.quad = quad
        }
        
        if rotate {
            edited = edited.imageRotatedByDegrees(degrees: CGFloat(item.angle))
        }
        
        if filter {
            edited = item.filter.apply(edited)
        }
        
        return edited
    }
    
}


extension EditPresenter: ImageScannerControllerDelegate {
    
    func imageScannerControllerDidEditScan(_ results: ImageEditResults?) {
        guard let item = visibleItem, let index = visibleIndex else { return }
        guard let results = results else { return }

        var original = results.quad
        if item.angle != 0 {
            let originalSize = item.original.size
            let targetSize = item.angle % 180 != 0 ? originalSize.reverse : originalSize
            let targetAngle = CGFloat(-item.angle) * .pi/180
            // revert to original
            original = original.scale(targetSize, originalSize, withRotationAngle: targetAngle)
        }
        
        item.originalQuad = original
        item.quad = results.quad
        
        self.dataSource[index] = item
        
        edit()
    }
    

}
