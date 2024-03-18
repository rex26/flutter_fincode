#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_fincode.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_fincode'
  s.version          = '0.0.1'
  s.summary          = 'A plug-in to add support for Fincode payments on Flutter applications.'
  s.description      = <<-DESC
A plug-in to add support for Fincode payments on Flutter applications.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  # The Prod environment needs to modify the path: Frameworks/Release/FincodeSDK.xcframework
  s.ios.vendored_frameworks = 'Frameworks/Debug/FincodeSDK.xcframework'
  s.vendored_frameworks = 'FincodeSDK.xcframework'
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
