#
#  Be sure to run `pod spec lint WordCloud.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "WordCloud"
  spec.version      = "0.0.1"
  spec.summary      = "Rushed WordCloud port of Lion and the Lamb app"
  spec.description  = "Rushed WordCloud port of Lion and the Lamb app. NOTE: Dont use this, convert it to swift first."
  spec.homepage     = "https://github.com/PetahChristian/LionAndLamb"
  spec.license      = { "type" => "MIT", :file => 'LICENSE.txt' }
  spec.author       = { "Lion And Lamb" => "Petah Christian" }
  spec.source       = { "git" => "https://github.com/ricardolpd/LionAndLamb.git", :tag => spec.version.to_s }
  spec.source_files = "WordCloud/**/*.{h,m}"
  spec.platform     = :ios, '12.0'
  spec.public_header_files = "WordCloud/**/*.h"
  # spec.requires_arc = true
  
end
