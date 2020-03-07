//
//  PullToRefresh.swift
//  MusicPlayer
//
//  Created by IgorBizi@mail.ru on 8/2/17.
//  Copyright © 2017 IgorBizi@mail.ru. All rights reserved.
//

import Foundation
import PullToRefreshKit

extension UIScrollView {
    
    func addPullToRefresh(closure: @escaping ()->()) {
        let header = DefaultRefreshHeader.header()
        header.setText("Pull to refresh".localized, mode: .pullToRefresh)
        header.setText("Release to refresh".localized, mode: .releaseToRefresh)
        header.setText("Success".localized, mode: .refreshSuccess)
        header.setText("Refreshing...".localized, mode: .refreshing)
        header.setText("Failed".localized, mode: .refreshFailure)
        header.textLabel.font = UIFont._LatoRegular(14)
        header.tintColor = LoadingHud.color
        header.imageRenderingWithTintColor = true
        configRefreshHeader(with: header, container: self) {
            closure()
        }
    }
    
    func stopRefreshing() {
        switchRefreshHeader(to: .normal(.none, 0))
    }
}
