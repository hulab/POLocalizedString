Pod::Spec.new do |spec|

  spec.name                 = 'POLocalizedString'
  spec.version              = '0.1.0'
  spec.license              = 'MIT'
  spec.homepage             = 'https://git.hulab.co/maxep/POLocalizedString'
  spec.authors              = { 'Andrej Mihajlov' => 'and@codeispoetry.ru' }
  spec.summary              = 'Gettext translations for iOS.'
  spec.source               = { :git => 'https://git.hulab.co/maxep/POLocalizedString.git', :tag => spec.version.to_s, :submodules => true }

  spec.source_files         = 'POLocalizedString/*.{h,m,mm}', 'muParser/src/*.cpp', 'muParser/include/*.h'
  spec.exclude_files        = 'muParser/src/muParserTest.cpp', 'muParser/src/muParserTest.h'
  spec.private_header_files = 'muParser/include/*.h'

  spec.framework            = 'Foundation'
  spec.libraries            = 'c++'
  spec.requires_arc         = true
  spec.platform             = :ios, '8.0'

end
