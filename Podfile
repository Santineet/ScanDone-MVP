source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

inhibit_all_warnings!
use_frameworks!

target 'Project' do
    pod 'SnapKit', '~> 4.2.0'
    pod 'DeviceKit', :git => 'https://github.com/devicekit/DeviceKit.git', :branch => 'master'
    pod 'Firebase/Core', '~> 5'
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'SDWebImage'
    pod 'Alamofire', '~> 4.8.0'
    pod 'SVProgressHUD'
    pod 'FontBlaster', '~> 4.1.0'
    pod 'GradientView'
    pod 'Groot', '~> 2'
    pod 'MagicalRecord'
    pod 'R.swift.Library'

    pod 'Then', '~> 2.4.0'
    pod 'Reusable', '~> 4.0.5'
    pod 'Localize-Swift'
    pod 'CHTCollectionViewWaterfallLayout/Swift'
    pod 'SwiftyGif', '~> 4.1.0'
    pod 'FileKit', '~> 5.0.0'
    pod 'AnimatedCollectionViewLayout', '~> 0.4.0'
    pod 'SPPermission/PhotoLibrary'
    pod 'SPPermission/Camera'
    pod 'PullToRefreshKit'
    pod 'ReachabilitySwift'
    pod 'SwiftyTesseract'
end

 
#Groot fix
post_install do |installer|
    `find Pods -regex 'Pods/Groot.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)Groot\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end
