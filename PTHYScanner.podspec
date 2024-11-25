#
# Be sure to run `pod lib lint PTHYScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PTHYScanner'
  s.version          = '0.0.1'
  s.swift_versions   = "4.0"
  s.summary          = 'A customizable QR code scanner for iOS.'
  s.description      = <<-DESC
  PTHYScanner provides a simple API for real-time QR code scanning in iOS apps.
                       DESC

  s.homepage         = 'https://github.com/songvuthy/PTHYScanner.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Song Vuthy' => 'songvuthy93@gmail.com' }
  s.source           = { :git => 'https://github.com/songvuthy/PTHYScanner.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'PTHYScanner/Classes/**/*'
  s.resources    = "PTHYScanner/Assets/**/*.xcassets"

  s.frameworks   = 'UIKit', 'AVFoundation'
  # s.dependency 'AFNetworking', '~> 2.3'
end
