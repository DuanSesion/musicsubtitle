//
//  WPCommand.swift
//  wupen
//
//  Created by 栾昊辰 on 2024/4/24.
//

import UIKit


// MARK: 当前KeyWindow
var WPKeyWindowDev = UIApplication.shared.windows.first { $0.isKeyWindow }
// MARK: 屏幕宽
var WPScreenWidth:CGFloat { get { return UIScreen.main.bounds.width } }
// MARK: 屏幕高
var WPScreenHeight:CGFloat {  get { return UIScreen.main.bounds.height } }
// MARK: iPad
var isiPad:Bool {  get { return (UIDevice.current.userInterfaceIdiom == .pad) } }
// MARK: app版本
var WPVersion:String { get { return (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "1.0.0" } }
// MARK: 状态栏高
var kStatusBarHeight:CGFloat { get { return (WPKeyWindowDev?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20.0) } }
var kNavigationBarHeight:CGFloat { get { return (WPKeyWindowDev?.windowScene?.statusBarManager?.statusBarFrame.height ?? 20.0) + 44.0 } }
// MARK: RGB颜色
func rgba(_ r:CGFloat,_ g:CGFloat,_ b:CGFloat,_ a:CGFloat=1) ->UIColor {  return UIColor.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a) }
// MARK: 本地化语言
func localizedString(_ key:String)->String? {return Bundle.main.localizedString(forKey: key, value: nil, table: "Localized")}

public let disposeBag:DisposeBag = DisposeBag()


