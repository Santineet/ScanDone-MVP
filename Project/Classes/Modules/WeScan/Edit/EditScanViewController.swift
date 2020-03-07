//
//  EditScanViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/12/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation

/// The `EditScanViewController` offers an interface for the user to edit the detected quadrilateral.
final class EditScanViewController: UIViewController {
    
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.isOpaque = true
        imageView.image = image
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy private var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setAttributedTitle(.init(string: "Cancel".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoRegular(12), .kern: 1.2 ]), for: .normal)
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }()
    
    lazy private var quadView: QuadrilateralView = {
        let quadView = QuadrilateralView()
        quadView.editable = true
        quadView.layer.masksToBounds = false
        quadView.clipsToBounds = false
        quadView.translatesAutoresizingMaskIntoConstraints = false
        return quadView
    }()
    
    lazy private var doneButton: UIButton = {
        let button = RoundButton()
        button.backgroundColor = .white
        button.cornerRadius = 3
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setAttributedTitle(.init(string: "Done".localized.uppercased(), attributes: [ .foregroundColor: UIColor._green3, .font: UIFont._RobotoMedium(14), .kern: 1.4 ]), for: UIControl.State())
//        button.setTitle("Done".localized, for: .normal)
//        button.titleLabel?.font = ._LatoRegular(18)
        button.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        button.setTitleColor(navigationController?.navigationBar.tintColor, for: .normal)
        return button
    }()

    private lazy var touchDownView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()

    /// The image the quadrilateral was detected on.
    private let image: UIImage
    
    /// The detected quadrilateral that can be edited by the user. Uses the image's coordinates.
    private var quad: Quadrilateral
    
    private var zoomGestureController: ZoomGestureController!
    
    private var quadViewWidthConstraint = NSLayoutConstraint()
    private var quadViewHeightConstraint = NSLayoutConstraint()
    
    // MARK: - Life Cycle
    
    init(image: UIImage, quad: Quadrilateral?, rotateImage: Bool = true) {
        self.image = rotateImage ? image.applyingPortraitOrientation() : image
        self.quad = quad ?? EditScanViewController.defaultQuad(forImage: image)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor._green2
        setAttributedTitle("Crop".localized.uppercased())
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationController?.isNavigationBarHidden = false
        
//        imageView.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
//        imageView.layer.shadowOpacity = 1
//        imageView.layer.shadowRadius = 20
//        imageView.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        view.addSubview(imageView)
        view.addSubview(quadView)
        view.addSubview(touchDownView)
        
        view.addSubview(doneButton)
        doneButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(self.view.safeArea.bottom).inset(20)
            make.height.equalTo(doneButton.intrinsicContentSize.height+44)
        }
        
        touchDownView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(50)
            make.top.equalTo(view.safeArea.top).inset(40)
            make.bottom.equalTo(doneButton.snp.top).inset(-45)
        }
        
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(touchDownView)
        }
        
        quadViewWidthConstraint = quadView.widthAnchor.constraint(equalToConstant: 0.0)
        quadViewHeightConstraint = quadView.heightAnchor.constraint(equalToConstant: 0.0)
        let quadViewConstraints = [
            quadView.centerXAnchor.constraint(equalTo: touchDownView.centerXAnchor),
            quadView.centerYAnchor.constraint(equalTo: touchDownView.centerYAnchor),
            quadViewWidthConstraint,
            quadViewHeightConstraint
        ]
        NSLayoutConstraint.activate(quadViewConstraints)
        
        
        zoomGestureController = ZoomGestureController(image: image, quadView: quadView)
        
        let touchDown = UILongPressGestureRecognizer(target: zoomGestureController, action: #selector(zoomGestureController.handle(pan:)))
        touchDown.minimumPressDuration = 0
        touchDownView.addGestureRecognizer(touchDown)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustQuadViewConstraints()
        displayQuad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Work around for an iOS 11.2 bug where UIBarButtonItems don't get back to their normal state after being pressed.
        navigationController?.navigationBar.tintAdjustmentMode = .normal
        navigationController?.navigationBar.tintAdjustmentMode = .automatic
    }
    
    // MARK: - Setups
     
    @objc func cancelButtonTapped() {
        if let imageScannerController = navigationController as? ImageScannerController {
            imageScannerController.dismiss(animated: true, completion: nil)
            imageScannerController.imageScannerDelegate?.imageScannerControllerDidCancel(imageScannerController)
        }
    }
    
    @objc func doneButtonTapped() {
        guard let quad = quadView.quad,
            let ciImage = CIImage(image: image) else {
                if let imageScannerController = navigationController as? ImageScannerController {
                    let error = ImageScannerControllerError.ciImageCreation
                    imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
                }
                return
        }
        
        if let vc = navigationController as? ImageScannerController {
            var results = image.crop(quad: quad, quadViewSize: quadView.bounds.size)
            if let results = results {
                self.quad = results.quad
            }
            vc.imageScannerDelegate?.imageScannerControllerDidEditScan(results)
            vc.dismiss(animated: true, completion: nil)
        }
    }
    
    private func displayQuad() {
        let imageSize = image.size
        let imageFrame = CGRect(origin: quadView.frame.origin, size: CGSize(width: quadViewWidthConstraint.constant, height: quadViewHeightConstraint.constant))
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: imageSize, aspectFillInSize: imageFrame.size)
        let transforms = [scaleTransform]
        let transformedQuad = quad.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: false)
    }
    
    /// The quadView should be lined up on top of the actual image displayed by the imageView.
    /// Since there is no way to know the size of that image before run time, we adjust the constraints to make sure that the quadView is on top of the displayed image.
    private func adjustQuadViewConstraints() {
        let frame = AVMakeRect(aspectRatio: image.size, insideRect: imageView.bounds)
        quadViewWidthConstraint.constant = frame.size.width
        quadViewHeightConstraint.constant = frame.size.height
    }
    
    /// Generates a `Quadrilateral` object that's centered and one third of the size of the passed in image.
    static func defaultQuad(forImage image: UIImage) -> Quadrilateral {
        let topLeft = CGPoint(x: image.size.width / 3.0, y: image.size.height / 3.0)
        let topRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: image.size.height / 3.0)
        let bottomRight = CGPoint(x: 2.0 * image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        let bottomLeft = CGPoint(x: image.size.width / 3.0, y: 2.0 * image.size.height / 3.0)
        
        let quad = Quadrilateral(topLeft: topLeft, topRight: topRight, bottomRight: bottomRight, bottomLeft: bottomLeft)
        
        return quad
    }

}


public struct ImageEditResults {
    
    var image: UIImage
    var quad: Quadrilateral
    var quadViewSize: CGSize

}
