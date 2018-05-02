Pod::Spec.new do |s|
  s.name             = 'Defaults'
  s.version          = '1.0.0'
  s.summary          = 'UserDefaults, the generic way.'
  s.description      = <<-DESC
Defalts wraps UserDefaults and allow you to interact with it in a simple, clear and type safe manner.
  DESC
  s.homepage         = 'https://github.com/oreninit/Defaults'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'oreninit' => 'oreninit@gmail.com' }
  s.source           = { :git => 'https://github.com/oreninit/Defaults.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/oreninit'
  s.ios.deployment_target = '9.3'
  s.source_files = 'Defaults/Classes/**/*'
  s.frameworks = 'Foundation'
  end
