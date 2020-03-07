//
//  ImageRecognizerViewController.swift
//
//
//  Created by IgorBizi@mail.ru on 5/15/16.
//  Copyright © 2016 IgorBizi@mail.ru. All rights reserved.
//

import UIKit

class ImageRecognizerViewController: UIViewController {
    
    var eventHandler: ImageRecognizerModuleInterface!
    var push = true
    
    @IBOutlet weak var textView: UITextView!
    var noContentView: NoContentView!

    lazy var recognizeLangsView: RecognizeLangsView = {
        let langsView = RecognizeLangsView.loadFromNib()
        langsView.didSelectLang = { [weak self] in
            ImageRecognizerLanguageItem.selected = $0
            self?.showsRecognizeLangs = false
            self?.updateSelectedLang($0)
        }
        langsView.didSelectClose = { [weak self] in
            self?.showsRecognizeLangs = false
        }
        return langsView
    }()

    var showsRecognizeLangs: Bool = false {
        didSet {
            if showsRecognizeLangs {
                view.insertSubview(recognizeLangsView, aboveSubview: horizontalMenuView)
                recognizeLangsView.snp.makeConstraints { make in
                    make.edges.equalTo(self.textView)
                }
                recognizeLangsView.fadeIn()
            } else {
                recognizeLangsView.fadeOut(willRemove: false)
            }

            recognizeLangsView.tableView.reloadData()
        }
    }
    
    lazy var horizontalMenuUserInterface: HorizontalMenuViewController = {
        let wireframe = HorizontalMenuWireframe()
        wireframe.presenter.delegate = self
        wireframe.userInterface.dataSource = [.export, .copy, .language]
        let userInterface = wireframe.userInterface!
        userInterface.view.reload()
        return userInterface
    }()
    
    lazy var horizontalMenuView: UIView = {
        return horizontalMenuUserInterface.contentView!
    }()
    
    lazy var horizontalMenuContainerView: UIView = {
        horizontalMenuUserInterface.collectionView.reload()

        let view = UIView()
        self.view.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            let view = HorizontalMenuItemView.loadFromNib()
            view.reload()
            let height = view.heightToFit(UIScreen.main.bounds.width)
            make.height.equalTo(height + (AppDependencies.appDelegate.window?.safeAreaInsets.bottom ?? 0))
        }
        return view
    }()
}


//LIFECYCLE
extension ImageRecognizerViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setAttributedTitle("OCR Results".localized().uppercased())
        removeBackBarButtonTitle()
        addNavBarShadow()
        
        view.backgroundColor = ._green1
        noContentView = NoContentView.create(.imageRecognizer, superview: view, color: .white)
        textView.text = nil
        textView.textColor = .white
        textView.font = ._RobotoRegular(18)
        textView.tintColor = .hexColor("018F2B")
        textView.delegate = self
        
        addChild(horizontalMenuUserInterface, childView: horizontalMenuView, superview: horizontalMenuContainerView)
        horizontalMenuView.reload()
        
        textView.textContainerInset = UIEdgeInsets.init(top: 20, left: 20, bottom: horizontalMenuView.frame.height + 20, right: 20)

        eventHandler.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        eventHandler.viewDidAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
}


//EVENTS
extension ImageRecognizerViewController {

    @IBAction func copyButtonAction(_ sender: Any) {
        eventHandler.didSelectCopy()
    }
    
    @IBAction func shareButtonAction(_ sender: Any) {
        eventHandler.didSelectShare()
    }
    
    @objc func selectedLangButtonTapped() {
        showsRecognizeLangs = !showsRecognizeLangs
    }
}


//METHODS
extension ImageRecognizerViewController {
    
    func updateSelectedLang(_ lang: ImageRecognizerLanguageItem) {
        eventHandler.didSelectRecognizeLang()
    }
    
}


extension ImageRecognizerViewController: UITextViewDelegate {

}


extension ImageRecognizerViewController: ImageRecognizerViewInterface {
    
}

extension ImageRecognizerViewController: HorizontalMenuDelegate {
    func moduleHorizontalMenu_didSelect(_ item: HorizontalMenuItem) {
        switch item {
        case .export:
            eventHandler.didSelectShare()
        case .copy:
            horizontalMenuUserInterface.dataSource = [.export, .copied, .language]
            delay(2) { [weak self] in
                self?.horizontalMenuUserInterface.dataSource = [.export, .copy, .language]
            }
        case .language:
            selectedLangButtonTapped()
        case .copied:
            break
        default: break
        }
    }
}

