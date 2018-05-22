# RXAdView

## 内容

- [样例](#样例)
- [需要](#需要)
- [使用](#使用)
- [开始](#开始)
- [License](#license)

## 样例

![](https://github.com/AlphaDog13/RXAdView/blob/master/89B5706EAD63-1.gif)


## 需要

- iOS 8.0+
- Swift 3.0+

## 使用

### CocoaPods

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
pod 'RXAdView', '~> 0.1.0'
end
```

## 开始

### 初始化

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        //加载广告页
        window?.isHidden = false
        let adView = RXAdView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        adView.staySeconds = 10 //停留时间
        adView.skipBtnColor = .black //跳过按钮颜色
        adView.imgUrl = "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1526974707182&di=b4a1ac293871ea193364ad47d5eb38e9&imgtype=0&src=http%3A%2F%2Fimg5.duitang.com%2Fuploads%2Fitem%2F201508%2F28%2F20150828223722_WeZ4z.jpeg"
        adView.willDismiss = { //即将消失
            print("AdViewWillDismiss")
        }
        adView.bgImgClick = { //点击广告
            print("bgImgClick")
        }
        window?.addSubview(adView)

        return true
    }

}
```

## License

RXCalendarView is released under the MIT license. See LICENSE for details.
