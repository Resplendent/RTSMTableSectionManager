#
# Be sure to run `pod lib lint RTSMTableSectionManager.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "RTSMTableSectionManager"
  s.version          = "0.1.7"
  s.summary          = "A tool to help manage a relationship between enum types and UITableView sections."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  # s.description      = <<-DESC
  #                      DESC

  s.homepage         = "https://github.com/Resplendent/RTSMTableSectionManager"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Benjamin Maer" => "ben@resplendent.co" }
  s.source           = { :git => "https://github.com/Resplendent/RTSMTableSectionManager.git", :tag => "v#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'RTSMTableSectionManager/Classes/**/*'
#  s.resource_bundles = {
#    'RTSMTableSectionManager' => ['Pod/Assets/*.png']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'ResplendentUtilities', '~> 0.5.0'
end
