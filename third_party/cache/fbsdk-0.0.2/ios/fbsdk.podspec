#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'fbsdk'
  s.version          = '0.0.1'
  s.summary          = 'Facebook SDK (Unofficial) for Flutter'
  s.description      = 'Facebook SDK (Unofficial) for Flutter'
  s.homepage         = 'https://github.com/namqdam/fbsdk'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Nam Dam' => 'namqdam@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.ios.deployment_target = '8.0'

  s.subspec 'Core' do |ss|
    ss.dependency     'FBSDKCoreKit'
    ss.source_files = 'RCTFBSDK/core/*.{h,m}'
  end

  s.subspec 'Login' do |ss|
    ss.dependency     'FBSDKLoginKit'
    ss.source_files = 'RCTFBSDK/login/*.{h,m}'
  end

  s.subspec 'Share' do |ss|
    ss.dependency     'FBSDKShareKit'
    ss.source_files = 'RCTFBSDK/share/*.{h,m}'
  end  
end

