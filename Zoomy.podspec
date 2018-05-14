Pod::Spec.new do |s|
  s.name             = 'Zoomy'
  s.version          = '1.7.2'
  s.summary          = 'Zoomy allows UIScrollView like zooming on UIImageViews in any view hierarchy'

  s.description      = <<-DESC
  Zoomy allows UIScrollView like zooming on UIImageViews in any view hierarchy with close to no alterations to clients layout. Zoomy works by initialy performing translate and scale manipulations on a view mimicking the original view that is to bee zoomed from, triggered by a pinch and (while the pinch has started) a pan gesture. As soon as the initial gesture is done a scrollView is placed and configured in the optimal postion in relation to the last location of the manipulated view. From this point on all manipulations are happening inside a scrollview and behave like you'd expect it to do.
                       DESC

  s.homepage         = 'https://github.com/mennolovink/Zoomy'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Menno Lovink' => 'mclovink@me.com' }
  s.source           = { :git => 'https://github.com/mennolovink/Zoomy.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Zoomy/Classes/**/*'
  
  s.dependency 'PureLayout', '~> 3.0'
  s.dependency 'InjectableLoggers', '~> 1.0'
end
