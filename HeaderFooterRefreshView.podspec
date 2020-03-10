#
# Be sure to run `pod lib lint HeaderFooterRefreshView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HeaderFooterRefreshView'
  s.version          = '1.0.0'
  s.summary          = 'HeaderFooterRefreshView is the library to config custom pull-to-refresh for header and footer of any subclass of UIScrollView'
  s.description      = <<-DESC
HeaderFooterRefreshView is the library to config custom pull-to-refresh for header and footer of any subclass of UIScrollView in two modes: manual and auto.
Manual behaviour similar to original UIRefreshControl.
Auto behaviour triggers selector when UIScrollView reaches minimum offset for header and maximum offset for footer.
                       DESC
  s.homepage         = 'https://github.com/Meggapixxel/HeaderFooterRefreshView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Meggapixxel' => 'zhydenkodeveloper@gmail.com' }
  s.source           = { :git => 'https://github.com/Meggapixxel/HeaderFooterRefreshView.git', :tag => s.version.to_s }
  s.platform = :ios, '10.0'
  s.swift_version = '5.0'
  s.source_files = 'Source/**/*'
  s.frameworks = 'UIKit'
end
