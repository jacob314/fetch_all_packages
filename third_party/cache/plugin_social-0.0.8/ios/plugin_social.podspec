#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'plugin_social'
  s.version          = '0.0.7'
  s.summary          = 'A new flutter plugin project.'
  s.description      = 'A new Flutter plugin for Sign in with SMS/Email via AccountKit.'
  s.homepage         = 'https://gitlab.com/trunghieutran/plugin_social'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Le Anh Tuan' => 'leanhtuan110596@gmail.com>' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  
  s.ios.deployment_target = '8.0'

  s.dependency 'AccountKit'
  s.static_framework = true

end

