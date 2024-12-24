Pod::Spec.new do |spec|
  spec.name                   = "OmniSegmentKit"
  spec.version                = "1.0.3-beta.1"
  spec.authors                = "Lewis"
  spec.summary                = "beBit-Tech App Popup SDK."
  spec.homepage               = "https://github.com/beBit-tech/bebit-tech-ios-app-sdk"
  spec.source                 = { :git => 'https://github.com/beBit-tech/bebit-tech-ios-app-sdk.git', :tag => spec.version }
  spec.platform               = :ios, '12.0'
  spec.swift_version          = '5.0'
  spec.requires_arc           = true
  spec.ios.deployment_target  = '12.0'
  spec.ios.frameworks         = 'AdSupport'

  spec.dependency 'Alamofire', '~> 5.4'
  spec.dependency 'FMDB', '~> 2.7'

  spec.static_framework = true

  spec.preserve_paths         = "OmniSegmentKit.xcframework", "dSYM"
  spec.vendored_frameworks    = 'OmniSegmentKit.xcframework'
end
