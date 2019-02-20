#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'document_chooser'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter chooser to allow users to pick documnet files avaialble on ther device'
  s.description      = <<-DESC
A Flutter chooser to allow users to pick documnet files avaialble on ther device
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '8.0'
end

