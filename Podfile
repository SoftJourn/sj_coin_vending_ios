source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target 'SJCoinsVendingMachine' do
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.0'
    pod 'SwiftyJSON', git: 'https://github.com/BaiduHiDeviOS/SwiftyJSON.git', branch: 'swift3'
    pod 'SwiftyUserDefaults'
    pod 'PromiseKit', '~> 4.0'
    pod 'SVProgressHUD', :git => 'https://github.com/SVProgressHUD/SVProgressHUD.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end

#pod 'ObjectMapper', '~> 1.2'
#pod 'Kingfisher', '~> 2.3'