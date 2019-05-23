#
#  Be sure to run `pod spec lint XXTimeMonitor.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "XXTimeMonitor"
  s.version      = "1.0.0"
  s.license      = "MIT"
  s.summary      = "一个简单的App启动计时工具"
  s.homepage     = "https://github.com/xxg90s/XXGravityBall"
  s.source       = { :git => "https://github.com/xxg90s/XXTimeMonitor.git", :tag => "#{s.version}" }
  s.source_files = "XXTimeMonitor/XXTimeMonitorDemo/XXTimeMonitorDemo/XXTimeMonitor/*.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, "7.0"
  s.frameworks   = "UIKit", "Foundation"
  s.author             = { "xxg90s" => "xxg90s@163.com" }
  s.social_media_url   = "https://github.com/xxg90s"

end
