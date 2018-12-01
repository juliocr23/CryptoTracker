# Uncomment the next line to define a global platform for your project
 platform :ios, '9.0'

target 'CryptoTracker' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for CryptoTracker

source 'https://github.com/CocoaPods/Specs.git'
# ignore all warnings from all pods
inhibit_all_warnings!

pod 'Alamofire'
pod 'SVProgressHUD'
pod 'SwiftyJSON'
pod 'Charts', :git => 'https://github.com/danielgindi/Charts.git', :branch => 'master'
pod 'ChameleonFramework'
pod 'AlamofireImage', '~> 3.5'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end


