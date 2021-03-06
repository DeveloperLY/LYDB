#
# Be sure to run `pod lib lint LYDB.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LYDB'
  s.version          = '0.9.0'
  s.summary          = 'LYDB.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Sqlite 数据库面向对象简单封装
                       DESC

  s.homepage         = 'https://github.com/DeveloperLY/LYDB'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'DeveloperLY' => 'coderyliu@gmail.com' }
  s.source           = { :git => 'https://github.com/DeveloperLY/LYDB.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'LYDB/Classes/**/*'
  
  # s.resource_bundles = {
  #   'LYDB' => ['LYDB/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = ''
  s.libraries =  'sqlite3.0'
  # s.dependency 'AFNetworking', '~> 2.3'
end
