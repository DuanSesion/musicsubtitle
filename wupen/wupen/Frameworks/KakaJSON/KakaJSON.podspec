
Pod::Spec.new do |s|
    s.name              = 'KakaJSON'
    s.version           = '1.0.0'
    s.summary           = 'An easy way to use pull-to-refresh and loading-more'
    s.description       = 'An easiest way to give pull-to-refresh and loading-more to any UIScrollView. Using swift!'
    s.homepage          = 'https://github.com/KakaJSON'

    s.license           = { :type => 'MIT', :file => 'LICENSE' }
    s.authors           = { 'lihao' => 'lihao_ios@hotmail.com'}
    s.social_media_url  = 'https://github.com/KakaJSON'
    s.platform          = :ios, '8.0'
    s.source            = {:git => 'https://github.com/KakaJSON.git', :tag => s.version}
    s.source_files      = ['Sources/**/*.{swift}']
 
    s.requires_arc      = true
    s.swift_version     = '5.0'
end
