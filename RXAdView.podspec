Pod::Spec.new do |s|

  s.name         = "RXAdView"
  s.version      = "0.0.5"
  s.summary      = "An launch Ad View"

  s.homepage     = "https://github.com/AlphaDog13/RXAdView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = "AlphaDog13"

  s.source       = { :git => "https://github.com/AlphaDog13/RXAdView.git", :tag => s.version.to_s }
  s.source_files = "RXAdView/*.swift"

  s.platform     = :ios, "8.0"
  s.requires_arc = true

  s.frameworks   = "Foundation", "UIKit"

end
