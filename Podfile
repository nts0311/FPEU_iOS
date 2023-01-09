# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

platform :ios, '13.0'

target 'FPEU' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for FPEU
  pod 'FSPagerView'
  pod 'IQKeyboardManagerSwift', '6.5.0'
  pod 'SDWebImage', '~> 5.0'
  pod 'Alamofire'
  pod 'SwiftEntryKit', '2.0.0'
  pod 'SVPullToRefresh'
  pod 'RxSwift', '6.5.0'
  pod 'RxCocoa', '6.5.0'
  pod "StompClientLib"
  pod 'GoogleMaps'
  pod 'RxCoreLocation', '~> 1.5.0'
  pod 'TagListView', '~> 1.4.1'
  pod 'GooglePlaces', '7.1.0'
  pod 'FirebaseMessaging'
  pod 'Cosmos', '~> 23.0'
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        # Force CocoaPods targets to always build for x86_64
        config.build_settings['ARCHS[sdk=iphonesimulator*]'] = 'x86_64'
      end
    end
  end
  
end
