#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'permissions'
  s.version          = '0.1.2'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/alexrabin/permissions'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Rabin Apps' => 'alex.m.rabin101@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3.3' }
  s.ios.deployment_target = '8.0'
end

