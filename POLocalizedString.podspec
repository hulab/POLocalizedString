Pod::Spec.new do |s|

  s.name                 = 'POLocalizedString'
  s.version              = '1.1.4'
  s.license              = 'MIT'
  s.homepage             = 'https://github.com/hulab/POLocalizedString'
  s.authors              = { 'Maxime Epain' => 'maxime.epain@gmail.com' }
  s.summary              = 'Gettext for iOS/OS X/watchOS/tvOS'
  s.source               = { :git => 'https://github.com/hulab/POLocalizedString.git', :tag => s.version.to_s, :submodules => true }

  s.source_files         = 'POLocalizedString/*.{h,m,mm,swift}', 'muParser/src/*.cpp', 'muParser/include/*.h'
  s.exclude_files        = 'muParser/src/muParserTest.cpp', 'muParser/src/muParserTest.h'
  s.private_header_files = 'muParser/include/*.h'

  s.framework            = 'Foundation'
  s.libraries            = 'c++'
  s.requires_arc         = true

  s.platform = :ios, :osx, :tvos, :watchos
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'

end
