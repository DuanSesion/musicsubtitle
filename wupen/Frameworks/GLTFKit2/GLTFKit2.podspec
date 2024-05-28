Pod::Spec.new do |s|
  s.name         = "GLTFKit2"
  s.version      = "1.0.0-rc3"
  s.summary      = "A framework for loading GL Transmission Format (glTF) models"
  s.homepage     = "https://github.com/warrenm/GLTFKit2"
  s.screenshots  = "https://github.com/warrenm/GLTFKit/raw/master/Images/screenshot-polly.jpg"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.author           = { "Warren Moore" => "wm@warrenmoore.net" }
  s.social_media_url = "http://twitter.com/warrenm"

  s.ios.deployment_target  = "11.0"
  s.osx.deployment_target  = "10.13"
  s.tvos.deployment_target = "11.0"

  s.source              = { :git => "https://github.com/warrenm/GLTFKit2.git", :tag => "#{s.version}" }
  s.source_files        = ["GLTFKit2/**/*.{h,m,swift,txt}", "deps/**/*.{h,m}"]
  s.public_header_files = ["GLTFKit2/**/*.h"]

  s.requires_arc        = true
end
