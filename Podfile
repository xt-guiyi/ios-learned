# Uncomment the next line to define a global platform for your project
platform :ios, '15.0'

target 'ios-learned' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SnapKit', '~> 5.7.0'
  pod 'Toast-Swift', '~> 5.1.1'
  pod 'FSPagerView', '~> 0.8.3'
  # Pods for ios-learned

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end
