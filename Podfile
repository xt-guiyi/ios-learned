# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'ios-learned' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SnapKit', '~> 5.7.0'
  pod 'Toast-Swift', '~> 5.1.1'
  pod 'FSPagerView', '~> 0.8.3'
  pod 'Alamofire', '~> 5.10.0'
  pod 'Moya', '~> 15.0.0'
  pod 'Moya/RxSwift', '~> 15.0.0'
  pod 'Moya/Combine', '~> 15.0.0'
  pod 'RxSwift', '~> 6.9.0'
  pod 'RxCocoa', '~> 6.9.0'
  pod 'RxDataSources', '~> 5.0.0'
  pod 'RxKeyboard', '~> 2.0.0'
  pod 'RxGesture', '~> 4.0.0'
  pod 'Kingfisher', '~> 8.0'
  # Pods for ios-learned

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
