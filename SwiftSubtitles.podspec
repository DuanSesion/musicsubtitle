
Pod::Spec.new do |spec|

  spec.name         = "SwiftSubtitles"
  spec.version      = "1.0.0"
  spec.summary      = "A short description of SwiftSubtitles."


  spec.description  = <<-DESC "xxxxxxx"
                   DESC

  spec.homepage     = "http://EXAMPLE/SwiftSubtitles"
  spec.license      = "MIT MARK"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "duan" => "duan@qq.com" }
 

   spec.platform     = :ios
   spec.platform     = :ios, "13.0"

  spec.source       = { :git => "http://xxx/SwiftSubtitles.git", :tag => "#{spec.version}" }
  #【潮汐注释】导入本地私有库
  spec.vendored_frameworks = ['Frameworks/SwiftSubtitles.framework']
 

end
