Pod::Spec.new do |s|
  s.name = 'LayerKit'
  s.version = '0.7.13'
  s.summary = 'LayerKit is the iOS client interface for the Layer communications cloud.'
  s.license = 'Commercial'
  s.authors = {"Blake Watters"=>"blake@layer.com", "Klemen Verdnik"=>"klemen@layer.com"}
  s.homepage = 'http://layer.com'
  s.libraries = 'z'
  s.requires_arc = true
  s.xcconfig = {"ENABLE_NS_ASSERTIONS"=>"YES"}
  s.source = { git: 'git@github.com:layerhq/releases-ios.git', tag: "v#{s.version}" }

  s.platform = :ios, '7.0'
  s.ios.platform             = :ios, '7.0'
  s.ios.preserve_paths       = 'LayerKit.embeddedframework/LayerKit.framework'
  s.ios.public_header_files  = 'LayerKit.embeddedframework/LayerKit.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'LayerKit.embeddedframework/LayerKit.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'LayerKit.embeddedframework/LayerKit.framework'
  s.ios.frameworks = ["CFNetwork", "Security", "MobileCoreServices", "SystemConfiguration"]
end
