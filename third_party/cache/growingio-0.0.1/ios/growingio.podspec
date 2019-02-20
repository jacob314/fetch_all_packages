#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'growingio'
  s.version          = '0.0.1'
  s.summary          = 'GrowingIO Plugin for Flutter app.'
  s.description      = <<-DESC
GrowingIO Plugin for Flutter app.
                       DESC
  s.homepage         = 'https://pantao.onmr.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pan Tao' => '54778899@qq.com.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'GrowingCoreKit'

  s.ios.deployment_target = '8.0'
end

