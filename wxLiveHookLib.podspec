#
# Be sure to run `pod lib lint wxLiveHookLib.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'wxLiveHookLib'
  s.version          = '0.1.0'
  s.summary          = 'wxLiveHookLib....'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
把微信变成远程视频主机
                       DESC

  s.homepage         = 'https://github.com/yh8577/wxLiveHookLib'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yh8577@126.com' => 'jyh8577@outlook.com' }
  s.source           = { :git => 'https://github.com/yh8577/wxLiveHookLib.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'wxLiveHookLib/Classes/**/*'
  
  # s.resource_bundles = {
  #   'wxLiveHookLib' => ['wxLiveHookLib/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.frameworks = 'UIKit', 'CoreGraphics', 'CoreVideo', 'QuartzCore', 'OpenGLES', 'VideoToolbox', 'AudioToolbox', 'CoreMedia', 'AVFoundation', 'Foundation'
    s.dependency 'LFLiveKit'
end
