//
//  ScannerViewController.swift
//  WeScan
//
//  Created by Boris Emorine on 2/8/18.
//  Copyright © 2018 WeTransfer. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

/// The `ScannerViewController` offers an interface to give feedback to the user regarding quadrilaterals that are detected. It also gives the user the opportunity to capture an image with a detected rectangle.
final class ScannerViewController: UIViewController, EditDelegate {
    
    /// Whether allow editing the image after didCapturePicture
    public var allowsEditing: Bool = false
    
    /// Whether shows the tip label
    private var hasShowedPlaceDocumentTip = false
    
    private var captureSessionManager: CaptureSessionManager?
    private let videoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    /// The view that shows the focus rectangle (when the user taps to focus, similar to the Camera app)
    private var focusRectangle: FocusRectangleView!
    
    /// The view that draws the detected rectangles.
    private let quadView = QuadrilateralView()
    
    /// Whether flash is enabled
    private var flashEnabled = false
    
    public var dataSource: [ImportItem] = []

    var businessCount = 0

    public var dataSourceCount: Int {
        return dataSource.count
    }
    
    var item: FolderItem?
    var type: EditPresenterType!
    
    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }
    
    private lazy var topGradientView: BZGradientView = {
        let view = BZGradientView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color1 = UIColor.black.alpha(0.8)
        view.color2 = UIColor.black.alpha(0)
        view.direction = .topToBottom
        self.view.insertSubview(view, belowSubview: topStackView)
        return view
    }()
    
    private lazy var bottomGradientView: BZGradientView = {
        let view = BZGradientView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color2 = UIColor.black.alpha(0.8)
        view.color1 = UIColor.black.alpha(0)
        view.direction = .topToBottom
        self.view.insertSubview(view, belowSubview: topStackView)
        return view
    }()
    
    /// Container view for top three buttons
    private lazy var topStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [])
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alignment = .fill
        view.axis = .horizontal
        view.distribution = .fill
        self.view.addSubview(view)
        return view
    }()
    
    lazy private var shutterButton: ShutterButton = {
        let button = ShutterButton.init(type: .custom)
        button.addTarget(self, action: #selector(captureImage(_:)), for: .touchUpInside)
        return button
    }()
    
    lazy private var shutterButtonLoadindHud: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView.init(style: .large)
        view.color = ._green1
        view.startAnimating()
        return view
    }()
    
    lazy private var albumButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: #selector(pickImageFromAlbum), for: .touchUpInside)
        button.setAttributedTitle(.init(string: "Gallery".localized.uppercased(), attributes: [.foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(10), .kern: 1]), for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 3
        button.layer.masksToBounds = true
        button.layer.backgroundColor = UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.4).cgColor
        return button
    }()
    
    
    
    lazy private var cancelButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.init(string: "Cancel".localized.uppercased(), attributes: [.foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(12), .kern: 1.2 ]), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Cancel".localized, for: .normal)
//        button.titleLabel?.font = ._RobotoMedium(12)
        button.addTarget(self, action: #selector(cancelImageScannerController), for: .touchUpInside)
//        button.tintColor = .white
        return button
    }()
    
    lazy private var autoScanButton: UIButton = {
        let button = UIButton()
        button.setAttributedTitle(.init(string: "Auto".localized.uppercased(), attributes: [.foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(12), .kern: 1.2 ]), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("Auto".localized, for: .normal)
//        button.titleLabel?.font = ._RobotoMedium(12)
        button.addTarget(self, action: #selector(toggleAutoScan), for: .touchUpInside)
//        button.tintColor = .white
        return button
    }()
    
    lazy private var autoScanButtonWidth: NSLayoutConstraint = { [unowned self] in
        let widthConstraint = self.autoScanButton.widthAnchor.constraint(equalToConstant: 0.0)
        return widthConstraint
        }()
    
    lazy private var flashButton: UIButton = {
        let button = UIButton()
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(R.image.icon_flash_off(), for: .normal)
        button.addTarget(self, action: #selector(toggleFlash), for: .touchUpInside)
        button.tintColor = .white
        
        return button
    }()
    
    lazy private var placeDocumentTipLabel: RoundLabel = {
        let label = RoundLabel()
        label.autolayout(true)
        label.backgroundColor = UIColor.black.alpha(0.6)
        label.font = ._RobotoRegular(14)
        label.textColor = .white
        label.text = "Place the document on the screen".localized
        label.textAlignment = .center
        return label
    }()
    
    lazy private var bottomLabel: UILabel = {
        let label = UILabel()
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        label.attributedText = .init(string: "Business Scan AI".localized.uppercased(), attributes: [ .paragraphStyle : paragraphStyle, .foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(10), .kern: 1 ])
        return label
    }()
    
    lazy private var saveButton: RoundButton = {
        let button = RoundButton()
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(saveAllImages), for: .touchUpInside)
//        button.setTitleColor(._green1, for: .normal)
//        button.setTitle(saveButtonTitle, for: .normal)
//        button.titleLabel?.font = ._LatoRegular(18)
        button.isHidden = true
        button.cornerRadius = 3
        return button
    }()
    
    private var saveButtonTitle: String {
        return dataSourceCount > 0 ?
            String(format: "Save (%ld)".localized.uppercased(), dataSourceCount) :
            "Save".localized.uppercased()
    }
    
    lazy private var capturingView: UIImageView = { [unowned self] in
        let view = UIImageView()
        view.frame = self.view.bounds
        return view
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = nil
        
        setupAlbumButton()
        setupViews()
        setupNavigationBar()
        setupConstraints()
        
        captureSessionManager = CaptureSessionManager(videoPreviewLayer: videoPreviewLayer)
        captureSessionManager?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(subjectAreaDidChange), name: NSNotification.Name.AVCaptureDeviceSubjectAreaDidChange, object: nil)
        
        toggleAutoScan()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNeedsStatusBarAppearanceUpdate()
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        CaptureSession.current.isEditing = false
        quadView.removeQuadrilateral()
        captureSessionManager?.start()
        UIApplication.shared.isIdleTimerDisabled = true
        reloadSaveButton()
        UIApplication.statusBar(style: .lightContent)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        videoPreviewLayer.frame = view.layer.bounds
        placeDocumentTipLabel.cornerRadius = 3
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        UIApplication.statusBar(style: .default)

        captureSessionManager?.stop()
        CaptureSession.current.isEditing = true
        
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        if device.torchMode == .on {
            toggleFlash()
        }
    }
    
    // MARK: - Setups
    
    private func setupAlbumButton() {
        PHPhotoLibrary.shared().register(self)
        updateAlbumButton()
    }
    
    private func setupViews() {
        view.backgroundColor = .black
        view.layer.addSublayer(videoPreviewLayer)
        quadView.translatesAutoresizingMaskIntoConstraints = false
        quadView.editable = false
        view.addSubview(quadView)
        
        view.addSubview(albumButton)
        
        view.addSubview(shutterButton)
        
        
        view.addSubview(saveButton)

        view.insertSubview(bottomGradientView, belowSubview: albumButton)
        bottomGradientView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(shutterButton.snp.top).inset(-50)
        }
        
        view.addSubview(topGradientView)
        topGradientView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(topStackView.snp.bottom).inset(-20)
        }
        
        view.addSubview(topStackView)
        view.addSubview(shutterButtonLoadindHud)
        shutterButtonLoadindHud.snp.makeConstraints { (make) in
            make.center.equalTo(shutterButton.snp.center)
        }
        shutterButtonLoadindHud.stopAnimating()

        view.addSubview(bottomLabel)
        bottomLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeArea.bottom).inset(20)
        }
        
        shutterButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(bottomLabel.snp.top).inset(-10)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
        if !hasShowedPlaceDocumentTip {
            view.addSubview(placeDocumentTipLabel)
            delay(3.0) { [weak self] in
                self?.placeDocumentTipLabel.fadeOut()
                self?.hasShowedPlaceDocumentTip = true
            }
        }
    }
    
    private func setupNavigationBar() {
        [cancelButton, UIView(), flashButton, UIView(), autoScanButton]
            .forEach(topStackView.addArrangedSubview(_:))

        autoScanButtonWidth.constant = autoScanButton.titleLabel!.intrinsicContentSize.width + 40.0
        
        NSLayoutConstraint.activate([
            cancelButton.widthAnchor.constraint(equalToConstant: cancelButton.intrinsicContentSize.width + 40.0),
            autoScanButtonWidth,
            flashButton.widthAnchor.constraint(equalToConstant: 100.0),
            flashButton.centerXAnchor.constraint(equalTo: topStackView.centerXAnchor)
        ])
        
        if UIImagePickerController.isFlashAvailable(for: .rear) == false {
            flashButton.setImage(R.image.icon_flash_off(), for: .normal)
            flashButton.tintColor = UIColor.lightGray
            flashButton.isEnabled = false
        }
        
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupConstraints() {
        var quadViewConstraints = [NSLayoutConstraint]()
        var topStackViewConstraints = [NSLayoutConstraint]()
        var placeDocumentTipLabelConstraints = [NSLayoutConstraint]()
        
        if !hasShowedPlaceDocumentTip {
            placeDocumentTipLabelConstraints = [
                placeDocumentTipLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
                placeDocumentTipLabel.widthAnchor.constraint(equalToConstant: placeDocumentTipLabel.intrinsicContentSize.width  + 40.0),
                placeDocumentTipLabel.heightAnchor.constraint(equalToConstant: placeDocumentTipLabel.intrinsicContentSize.height + 20.0),
                placeDocumentTipLabel.bottomAnchor.constraint(equalTo: shutterButton.topAnchor, constant: -30.0)
            ]
        }
        
        quadViewConstraints = [
            quadView.topAnchor.constraint(equalTo: view.topAnchor),
            view.bottomAnchor.constraint(equalTo: quadView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: quadView.trailingAnchor),
            quadView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ]
        
        if #available(iOS 11.0, *) {
            topStackViewConstraints = [
                topStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                view.safeAreaLayoutGuide.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
                topStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            ]
        } else {
            topStackViewConstraints = [
                topStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20.0),
                view.trailingAnchor.constraint(equalTo: topStackView.trailingAnchor),
                topStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            ]
        }
        
        topStackViewConstraints += [
            topStackView.heightAnchor.constraint(equalToConstant: 44.0)
        ]
        
        albumButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(albumButton.intrinsicContentSize.width+30)
            make.bottom.equalTo(view.safeArea.bottom).inset(20)
            make.leading.equalToSuperview().inset(20)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(saveButton.intrinsicContentSize.width+30)
            make.bottom.equalTo(albumButton.snp.bottom)
            make.trailing.equalToSuperview().inset(20)
        }
        
        NSLayoutConstraint.activate(
            quadViewConstraints + topStackViewConstraints + placeDocumentTipLabelConstraints
        )
        

    }
    
    func reloadSaveButton() {
        saveButton.setAttributedTitle(.init(string: saveButtonTitle, attributes: [.foregroundColor: UIColor._green3, .font: UIFont._RobotoMedium(10), .kern: 1 ]), for: .normal)
        saveButton.isHidden = dataSourceCount <= 0
        saveButton.snp.updateConstraints { (make) in
            make.width.equalTo(saveButton.intrinsicContentSize.width+30)
        }
    }
    
    // MARK: - Tap to Focus
    
    /// Called when the AVCaptureDevice detects that the subject area has changed significantly. When it's called, we reset the focus so the camera is no longer out of focus.
    @objc private func subjectAreaDidChange() {
        /// Reset the focus and exposure back to automatic
        do {
            try CaptureSession.current.resetFocusToAuto()
        } catch {
            let error = ImageScannerControllerError.inputDevice
            guard let captureSessionManager = captureSessionManager else { return }
            captureSessionManager.delegate?.captureSessionManager(captureSessionManager, didFailWithError: error)
            return
        }
        
        /// Remove the focus rectangle if one exists
        CaptureSession.current.removeFocusRectangleIfNeeded(focusRectangle, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard  let touch = touches.first else { return }
        let touchPoint = touch.location(in: view)
        let convertedTouchPoint: CGPoint = videoPreviewLayer.captureDevicePointConverted(fromLayerPoint: touchPoint)
        
        CaptureSession.current.removeFocusRectangleIfNeeded(focusRectangle, animated: false)
        
        focusRectangle = FocusRectangleView(touchPoint: touchPoint)
        view.insertSubview(focusRectangle, belowSubview: quadView)
        
        do {
            try CaptureSession.current.setFocusPointToTapPoint(convertedTouchPoint)
        } catch {
            let error = ImageScannerControllerError.inputDevice
            guard let captureSessionManager = captureSessionManager else { return }
            captureSessionManager.delegate?.captureSessionManager(captureSessionManager, didFailWithError: error)
            return
        }
    }
    
    // MARK: - Actions
    
    @objc private func captureImage(_ sender: ShutterButton) {
        switch sender.state_ {
        case .done:
            shutterButton.state_ = .start
        default:
            (navigationController as? ImageScannerController)?.flashToBlack()
            handleCapturingPicture()
            captureSessionManager?.capturePhoto()
        }
    }
    
    @objc private func toggleAutoScan() {
        if CaptureSession.current.isAutoScanEnabled {
            CaptureSession.current.isAutoScanEnabled = false
            autoScanButton.setAttributedTitle(.init(string: "Manual".localized.uppercased(), attributes: [.foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(12), .kern: 1.2 ]), for: .normal)
//            autoScanButton.setTitle("Manual".localized, for: .normal)
        } else {
            CaptureSession.current.isAutoScanEnabled = true
            autoScanButton.setAttributedTitle(.init(string: "Auto".localized.uppercased(), attributes: [.foregroundColor: UIColor.white, .font: UIFont._RobotoMedium(12), .kern: 1.2 ]), for: .normal)
//            autoScanButton.setTitle("Auto".localized, for: .normal)
        }
        
        autoScanButtonWidth.constant = autoScanButton.titleLabel!.intrinsicContentSize.width + 40.0
    }
    
    @objc private func toggleFlash() {
        let state = CaptureSession.current.toggleFlash()
        
        let flashImage = R.image.icon_flash_on()
        let flashOffImage = R.image.icon_flash_off()
        
        switch state {
        case .on:
            flashEnabled = true
            flashButton.setImage(flashImage, for: .normal)
            flashButton.tintColor = .yellow
        case .off:
            flashEnabled = false
            flashButton.setImage(flashOffImage, for: .normal)
            flashButton.tintColor = .white
        case .unknown, .unavailable:
            flashEnabled = false
            flashButton.setImage(flashOffImage, for: .normal)
            flashButton.tintColor = UIColor.lightGray
        }
    }
    
    @objc private func cancelImageScannerController() {
        guard let nvc = navigationController as? ImageScannerController else { return }
        
        if dataSource.isEmpty {
            nvc.dismiss(animated: true, completion: nil)
            nvc.imageScannerDelegate?.imageScannerControllerDidCancel(nvc)
        } else {
            Alert.show(title: "Do you want to Close?".localized, okTitle: "Close".localized, okStyle: .destructive, cancelButton: true, okEventHandler: { (_) in
                delay(1, closure: { [weak self] in
                    guard let nvc = self?.navigationController as? ImageScannerController else { return }
                    nvc.dismiss(animated: true, completion: nil)
                    nvc.imageScannerDelegate?.imageScannerControllerDidCancel(nvc)
                })
            })
        }
    }
    
    @objc private func pickImageFromAlbum() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        imageScannerController.imageScannerDelegate?.imageScannerControllerDidPickPhoto(imageScannerController)
        
        presentImagePickerInterface()
    }
    
    func presentImagePickerInterface() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }

        let picker = UIImagePickerController()
        picker.modalPresentationStyle = .fullScreen
        picker.sourceType = .photoLibrary
        picker.delegate = self
        imageScannerController.present(picker, animated: true, completion: nil)
    }
    
    @objc private func saveAllImages() {
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        imageScannerController.imageScannerDelegate?.imageScannerControllerDidSave(imageScannerController)
        
        presentEditInterface()
    }
    
    func presentEditInterface(indexPath: IndexPath? = nil, animated: Bool = true) {
        let wireframe = EditWireframe()
        wireframe.presenter.delegate = self
        wireframe.presenter.item = item
        wireframe.presenter.type = type
        if let indexPath = indexPath {
            wireframe.userInterface.initialIndexPath = IndexPath(item: 0, section: indexPath.item)
        }
        wireframe.presentInterface(self, animated: animated)
    }
}

extension ScannerViewController: RectangleDetectionDelegateProtocol {
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didFailWithError error: Error) {
        
        shutterButtonLoadindHud.stopAnimating()
        shutterButton.isUserInteractionEnabled = true
        
        guard let imageScannerController = navigationController as? ImageScannerController else { return }
        imageScannerController.imageScannerDelegate?.imageScannerController(imageScannerController, didFailWithError: error)
    }
    
    func didStartCapturingPicture(for captureSessionManager: CaptureSessionManager) {
        handleCapturingPicture()
        showCapturingFlashView()
    }
    
    func handleCapturingPicture() {
        CaptureSession.current.isEditing = true
        shutterButton.isUserInteractionEnabled = false
        albumButton.isUserInteractionEnabled = false
        saveButton.isUserInteractionEnabled = false
        shutterButtonLoadindHud.startAnimating()
    }
    
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didCapturePicture picture: UIImage, withQuad quad: Quadrilateral?) {
        shutterButtonLoadindHud.stopAnimating()

        guard self.isVisibleAndOnTop else { return }
        
        if allowsEditing {
            let editVC = EditScanViewController(image: picture, quad: quad)
            navigationController?.pushViewController(editVC, animated: false)
        } else {
            guard let imageScannerController = navigationController as? ImageScannerController else { return }

            if (businessCount == 0 && !CaptureSession.current.isAutoScanEnabled) || CaptureSession.current.isAutoScanEnabled {
                var fixedImage: UIImage
                if let imageQuad = quad, let results = picture.resultsWithQuad(imageQuad) {
                    fixedImage = results.croppedScan.image
                } else {
                    fixedImage = picture.applyingPortraitOrientation().withFixedOrientation()
                }
            
                imageScannerController.imageScannerDelegate?.imageScannerControllerDidCapture(
                    imageScannerController, picture: fixedImage
                )

                let item = ImportItem(fixedImage)
                dataSource.append(item)
            }
            
            CaptureSession.current.isEditing = false
            captureSessionManager.start()
            
            if !CaptureSession.current.isAutoScanEnabled {
                if businessCount < 2 {
                    businessCount += 1
                    
                    (navigationController as? ImageScannerController)?.flashToBlack()
                    handleCapturingPicture()
                    captureSessionManager.capturePhoto()
                } else {
                    businessCount = 0
                    shutterButton.state_ = .done
                    reloadSaveButton()
                }
            }
            
            if CaptureSession.current.isAutoScanEnabled {
                reloadSaveButton()
            }
            
        }
        
        shutterButton.isUserInteractionEnabled = true
        albumButton.isUserInteractionEnabled = true
        saveButton.isUserInteractionEnabled = true
    }
    
    func captureSessionManager(_ captureSessionManager: CaptureSessionManager, didDetectQuad quad: Quadrilateral?, _ imageSize: CGSize) {
        guard let quad = quad else {
            // If no quad has been detected, we remove the currently displayed on on the quadView.
            quadView.removeQuadrilateral()
            return
        }
        
        let portraitImageSize = CGSize(width: imageSize.height, height: imageSize.width)
        
        let scaleTransform = CGAffineTransform.scaleTransform(forSize: portraitImageSize, aspectFillInSize: quadView.bounds.size)
        let scaledImageSize = imageSize.applying(scaleTransform)
        
        let rotationTransform = CGAffineTransform(rotationAngle: CGFloat.pi / 2.0)

        let imageBounds = CGRect(origin: .zero, size: scaledImageSize).applying(rotationTransform)

        let translationTransform = CGAffineTransform.translateTransform(fromCenterOfRect: imageBounds, toCenterOfRect: quadView.bounds)
        
        let transforms = [scaleTransform, rotationTransform, translationTransform]
        
        let transformedQuad = quad.applyTransforms(transforms)
        
        quadView.drawQuadrilateral(quad: transformedQuad, animated: true)
    }
    
}


extension ScannerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    public func imagePickerControllerDidCancel(
        _ picker: UIImagePickerController
        ) {
        picker.dismiss(animated: true)
    }
    
    public func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
        guard let image = info[.originalImage] as? UIImage else { return }
        
        let item = ImportItem(image)
        dataSource.append(item)
        reloadSaveButton()

        picker.dismiss(animated: true)
    }
}

extension ScannerViewController {
    
    private func showCapturingFlashView() {
        self.capturingView.removeFromSuperview()
        capturingView = UIImageView()
        capturingView.frame = self.view.bounds
        
        capturingView.image = quadView.snapshot()
        view.insertSubview(capturingView, aboveSubview: quadView)
        
        let duration = 4.0
        UIView.animate(
            withDuration: duration,
            delay: 0,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 0.5,
            options: .curveEaseOut,
            animations: { [weak self] in
                guard let view = self?.capturingView else { return }
                view.frame.origin.y = view.frame.size.height
            },
            completion: { [unowned self] finished in
                if finished {
                    self.capturingView.removeFromSuperview()
                }
            }
        )
    }
}

extension ScannerViewController: PHPhotoLibraryChangeObserver {
    
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async { self.updateAlbumButton() }
    }
    
    private func updateAlbumButton() {
        albumButton.showLoadingHud(true, color: .white, style: .white)
        PHAsset.fetchLastPhoto(scaleTo: .constant(200.0)) { [weak self] image in
            guard let button = self?.albumButton else { return }
            button.showLoadingHud(false)
            if let image = image {
                button.setBackgroundImage(image.alpha(0.5), for: .normal)
            }
            button.fadeIn()
        }
    }
    
}
