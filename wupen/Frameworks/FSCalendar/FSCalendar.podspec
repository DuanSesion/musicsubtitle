Pod::Spec.new do |s|
  s.name = 'FSCalendar'
  s.version = '1.0.0'
  s.license = 'MIT'

  s.summary = 'A lightweight and easy-to-use FSCalendar for iOS.'
  s.homepage = 'https://relatedcode.com'
  s.author = { 'Related Code' => 'info@relatedcode.com' }

  s.source = { :git => 'https://github.com/relatedcode/FSCalendar.git', :tag => s.version }
  s.source_files = "FSCalendar/*.{h,m}"

  s.requires_arc = true
end
