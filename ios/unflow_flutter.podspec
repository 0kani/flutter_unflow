#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint unflow_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'unflow_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Tired of building the same simple screens over and over again? Empower your product team to create and ship content using the Unflow mobile SDK.'
  s.description      = <<-DESC
Tired of building the same simple screens over and over again? Empower your product team to create and ship content using the Unflow mobile SDK.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'Unflow'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
