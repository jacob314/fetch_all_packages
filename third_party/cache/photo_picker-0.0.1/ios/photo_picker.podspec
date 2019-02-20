#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'photo_picker'
  s.version          = '0.0.1'
  s.summary          = 'photo_picker for flutter.'
  s.description      = <<-DESC
Flutter photo_picker plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => './' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CTAssetsPickerController',  '~> 3.3.0'

  s.ios.deployment_target = '8.0'
end

