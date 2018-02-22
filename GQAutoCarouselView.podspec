Pod::Spec.new do |s|

  s.name         = "GQAutoCarouselView"
  s.version      = "1.0.0"
  s.summary      = "一款自动轮播视图，可以自定义可见item个数，支持自定义单个itemView，支持视图轮播方向设置"

  s.homepage     = "https://github.com/g763007297/GQAutoCarouselView"

  s.license      = "MIT (example)"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author       = { "developer_高" => "763007297@qq.com" }
  
  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/g763007297/GQAutoCarouselView.git", :tag => s.version.to_s }
  
  s.requires_arc = true
  
  s.source_files  = "GQAutoCarouselView/**/*.{h,m}"
  
  s.dependency "GQTimer"
  
end
