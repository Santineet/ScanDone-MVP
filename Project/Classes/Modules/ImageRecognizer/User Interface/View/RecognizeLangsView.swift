//
//  RecognizeLangsView.swift
//  Project
//
//  Created by Shane Gao on 2019/10/16.
//  Copyright © 2019 Igor Bizi. All rights reserved.
//

import UIKit

/// RecognizeLangCell
class RecognizeLangCell: UITableViewCell, Reusable {
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var imageView1: UIImageView = {
        let label = UIImageView()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .none
        
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
        }
        
        addSubview(imageView1)
        imageView1.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-30)
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

/// RecognizeLangTableView
final class RecognizeLangTableView: UITableView {
    
    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }
    
    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}

/// RecognizeLangsView
class RecognizeLangsView: UIView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var didSelectLang: ((ImageRecognizerLanguageItem) -> Void)?
    var didSelectClose: (() -> Void)?
}

extension RecognizeLangsView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        backView.backgroundColor = UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.75)
        
        tableView.rowHeight = 65
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .clear
        tableView.separatorColor = .clear
        
        tableView.register(cellType: RecognizeLangCell.self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(backgroundTapped))
        backView.addGestureRecognizer(tap)
        
        cancelButton.addTarget(self, action: #selector(backgroundTapped), for: .touchUpInside)
        cancelButton.backgroundColor = .white
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        cancelButton.setAttributedTitle(.init(string: "Cancel".localized.uppercased(), attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor._green3, .font: UIFont._RobotoMedium(14), .kern: 1.4 ]), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.roundCorners(.allCorners, radius: 3.0)
        cancelButton.roundCorners(.allCorners, radius: 3.0)
    }
}

extension RecognizeLangsView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return ImageRecognizerLanguageItem.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecognizeLangCell = tableView.dequeueReusableCell(for: indexPath)
        let lang = ImageRecognizerLanguageItem.allValues[indexPath.section]
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        cell.nameLabel.attributedText = .init(string: lang.title, attributes: [ .paragraphStyle: paragraphStyle, .foregroundColor: UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 1), .font: UIFont._RobotoRegular(14), .kern: 1.4 ])
        cell.imageView1.image = lang == .selected ? R.image.imageNavCheckedEnabled() : R.image.imageNavCheckedDisabled()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0001 : 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.016, green: 0.059, blue: 0.059, alpha: 0.15)
        return view
    }
}

extension RecognizeLangsView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let lang = ImageRecognizerLanguageItem.allValues[indexPath.section]
        didSelectLang?(lang)
    }
    
}

extension RecognizeLangsView {
    @objc func backgroundTapped() {
        didSelectClose?()
    }
}
