//
//  PreviewWireframe.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit


class ShareWireframe: Wireframe {
    
    var imageRecognizerDataManager: ImageRecognizerDataManagerLocal? = nil

    deinit {
        imageRecognizerDataManager = nil
    }
    
    func presentInterface(_ presentingVC: UIViewController, folder: FolderItem, files: [FileItem]) {
        let paths = files.map { $0.path }

        weak var weakSelf = self

        func callCompletion() {
            presentingVC.view.showLoadingHud(false)
            FolderItem.clearTemp()
        }
        
        func present(presentingVC: UIViewController, urls: [URL]) {
            Wireframe.presentShareInterface(presentingVC, activityItems: urls as [AnyObject], completionCanceled: {
                callCompletion()
            }, completionCompleted: {
                callCompletion()
            })
        }
        
        
        
        let actionPng = UIAlertAction.init(title: "Save as PNG".localized.uppercased(), style: .default) { (_) in
            
            presentingVC.view.showLoadingHud(true, backgroundColor: UIColor._light1)

            delay(0.5, closure: {
                var urls = [URL]()
                var error: Error?
                
                FolderItem.clearTemp()
                
                for i in paths {
                    if let data = UIImage(url: i.url)?.pngData() {
                        let filename = String(FileItem.fileNameFromPath(i)) + ".png"
                        let path = FolderItem.pathTemp + filename
                        do {
                            try data.write(to: path)
                            urls.append(path.url)
                        } catch (let error1) {
                            print(error1)
                            error = error1
                        }
                    }
                }
                if let error = error {
                    Alert.showError(error)
                }
                present(presentingVC: presentingVC, urls: urls)
            })
        }
        
        
        
        let actionJpg = UIAlertAction.init(title: "Save as JPG".localized.uppercased(), style: .default) { (_) in
            
            presentingVC.view.showLoadingHud(true, backgroundColor: UIColor._light1)

            delay(0.5, closure: {
                let urls = paths.map({ $0.url })
                present(presentingVC: presentingVC, urls: urls)
            })
        }
        
        
        
        let actionPdf = UIAlertAction.init(title: "Save as PDF".localized.uppercased(), style: .default) { (_) in
            
            presentingVC.view.showLoadingHud(true, backgroundColor: UIColor._light1)
            
            delay(0.5, closure: {
                var error: Error?
                
                FolderItem.clearTemp()
                
                var pages = [PDFPage]()
                for i in paths {
                    let page = PDFPage.imagePath(i.rawValue)
                    pages.append(page)
                }
                let filename = folder.name + ".pdf"
                let path = FolderItem.pathTemp + filename
                do {
                    try PDFGenerator.generate(pages, to: path.rawValue, dpi: .default)
                } catch (let error1) {
                    print(error1)
                    error = error1
                }
                
                if let error = error {
                    Alert.showError(error)
                }
                present(presentingVC: presentingVC, urls: [path.url])
            })
        }
        
        
        
        let actionText = UIAlertAction.init(title: "Save as TEXT".localized.uppercased(), style: .default) { (_) in
            
            var actions = [UIAlertAction]()
            for language in ImageRecognizerLanguageItem.allValues {
                let action = UIAlertAction(title: language.title, style: .default) { (_) in

                    ImageRecognizerLanguageItem.selected = language
                    
                    presentingVC.view.showLoadingHud(true, backgroundColor: UIColor._light1)

                    delay(0.5, closure: {
                        let images = files.map { $0.file }
                        let imageRecognizerDataManager = ImageRecognizerDataManagerLocal()
                        imageRecognizerDataManager.recognize(images: images, language: language) { (text) in
                            if let text = text {
                                Wireframe.presentShareInterface(presentingVC, activityItems: [text] as [AnyObject], completionCanceled: {
                                    callCompletion()
                                }, completionCompleted: {
                                    callCompletion()
                                })
                            } else {
                                Alert.showError(NoContentViewType.imageRecognizer.title ?? "")
                            }
                        }
                        weakSelf?.imageRecognizerDataManager = imageRecognizerDataManager
                    })
                    
                }
                actions.append(action)
            }
            Alert.show(style: .actionSheet, title: "Language".localized.uppercased() + ": ", okButton: false, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), cancelStyle: .cancel, sourceView: nil, actions: actions)
        }
        
        Alert.show(style: .actionSheet, okButton: false, cancelButton: true, cancelTitle: "Cancel".localized.uppercased(), cancelStyle: .cancel, sourceView: nil, actions: [actionText, actionPdf, actionPng, actionJpg])
    }
    

}


