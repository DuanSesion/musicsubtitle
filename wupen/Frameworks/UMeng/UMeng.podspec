
Pod::Spec.new do |spec|


  spec.name         = "UMeng"
  spec.version      = "0.0.1"
  spec.summary      = "A short description of UMFramework."


  spec.description  = <<-DESC "xxxxxxx"
                   DESC

  spec.homepage     = "http://EXAMPLE/UMFramework"
  spec.license      = "MIT MARK"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  spec.author             = { "duanshaoxiong" => "1026720995@qq.com" }
 

   spec.platform     = :ios
   spec.platform     = :ios, "10.0"

  spec.source       = { :git => "http://xxx/UMAPM.git", :tag => "#{spec.version}" }
  #【潮汐注释】导入本地私有库
  spec.vendored_frameworks = [
                           'UMeng/UMAPM.framework',
                           'UMeng/UMCommon.framework',
                           'UMeng/UMDevice.framework'
                           ]
  
  spec.source_files  = "UMeng", "UMeng/UMeng.h"


#  spec.source_files  = "UMAPM.framework", "UMAPM.framework/**/*.{h,m}"
#  spec.exclude_files = "UMAPM.framework/Exclude"

#  spec.public_header_files = "UUMeng.framework/**/*.h"


 #【潮汐注释】导入本地私有库的图片资源
# spec.resources = [
# './CXKeyBoardRes.bundle'
# ]

end
