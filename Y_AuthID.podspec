#
# Be sure to run `pod lib lint Y_AuthID.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  #名称
  s.name         = "Y_AuthID"
  #版本
  s.version      = "0.1.4"
  #简介
  s.summary      = "快速调用系统 TouchID/FaceID 进行身份验证"
  #详介
  s.description  = <<-DESC
  一个方法快速调用系统 TouchID/FaceID 进行身份验证
                   DESC

  #首页
  s.homepage     = "https://github.com/1ilI/Y_AuthID"
  #截图
  s.screenshots  = "https://raw.githubusercontent.com/1ilI/Y_PickerView/master/Y_PickerView.gif"

  #开源协议
  s.license      = { :type => "MIT", :file => "LICENSE" }
  #作者信息
  s.author             = { "1ilI" => "1ilI" }
  #iOS的开发版本
  s.ios.deployment_target = "8.0"
  #源码地址
  s.source       = { :git => "https://github.com/1ilI/Y_AuthID.git", :tag => "#{s.version}" }
  #源文件所在文件夹，会匹配到该文件夹下所有的 .h、.m文件
  s.source_files  = "Y_AuthID", "Y_AuthID/**/*.{h,m}"
  #依赖的framework
  s.framework  = "UIKit"
end
