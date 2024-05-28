//
//  GenerateUserSig.h
//  wupen
//
//  Created by 栾昊辰 on 2024/4/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  配置推流地址
 *  腾讯云域名管理页面：https://console.cloud.tencent.com/live/domainmanage
 */
static NSString * const PUSH_DOMAIN = @"txpush.lllmark.com";

/**
 *  配置拉流地址
 *  腾讯云域名管理页面： https://console.cloud.tencent.com/live/domainmanage
 */
static NSString * const PLAY_DOMAIN = @"txpull.lllmark.com";

/**
 * URL 鉴权Key
 */
static NSString * const LIVE_URL_KEY = @"a55916986c4c3dbcb18fa86d14de1b3e";

/**
 * 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
 * 当前应用的License LicenseUrl
 *
 * License Management View (https://console.cloud.tencent.com/live/license)
 * License URL of your application
 */
static NSString * const LICENSEURL = @"https://license.vod2.myqcloud.com/license/v2/1302550040_1/v_cube.license";

/**
 * 腾讯云License管理页面(https://console.cloud.tencent.com/live/license)
 * 当前应用的License Key
 *
 * License Management View (https://console.cloud.tencent.com/live/license)
 * License key of your application
 */
static NSString * const LICENSEURLKEY = @"99c5b06bcd045e37c1f2f6737601f431";

/**
 * 腾讯云 SDKAppId，需要替换为您自己账号下的 SDKAppId。
 *
 * 进入腾讯云实时音视频[控制台](https://console.cloud.tencent.com/rav ) 创建应用，即可看到 SDKAppId，
 * 它是腾讯云用于区分客户的唯一标识。
 */
/**
 * Tencent Cloud `SDKAppID`. Set it to the `SDKAppID` of your account.
 *
 * You can view your `SDKAppID` after creating an application in the [TRTC console](https://console.cloud.tencent.com/rav).
 * `SDKAppID` uniquely identifies a Tencent Cloud account.
 */
static const int SDKAppID = 1600033428;

/**
 *  签名过期时间，建议不要设置的过短
 *
 *  时间单位：秒
 *  默认时间：7 x 24 x 60 x 60 = 604800 = 7 天
 */
/**
 * Signature validity period, which should not be set too short
 * <p>
 * Unit: second
 * Default value: 604800 (7 days)
 */
static const int EXPIRETIME = 604800;

/**
 * 计算签名用的加密密钥，获取步骤如下：
 *
 * step1. 进入腾讯云实时音视频[控制台](https://console.cloud.tencent.com/rav )，如果还没有应用就创建一个，
 * step2. 单击您的应用，并进一步找到“快速上手”部分。
 * step3. 点击“查看密钥”按钮，就可以看到计算 UserSig 使用的加密的密钥了，请将其拷贝并复制到如下的变量中
 *
 * 注意：该方案仅适用于调试Demo，正式上线前请将 UserSig 计算代码和密钥迁移到您的后台服务器上，以避免加密密钥泄露导致的流量盗用。
 * 文档：https://cloud.tencent.com/document/product/647/17275#Server
 */
/**
 * Follow the steps below to obtain the key required for UserSig calculation.
 *
 * Step 1. Log in to the [TRTC console](https://console.cloud.tencent.com/rav), and create an application if you don’t have one.
 * Step 2. Find your application, click “Application Info”, and click the “Quick Start” tab.
 * Step 3. Copy and paste the key to the code, as shown below.
 *
 * Note: this method is for testing only. Before commercial launch, please migrate the UserSig calculation code and key to your backend server to prevent key disclosure and traffic stealing.
 * Reference: https://cloud.tencent.com/document/product/647/17275#Server
 */
static NSString * const SECRETKEY = @"97a89cd0c3c9383c247814d0ba58f0463d9d613ca36eae58993f26e0cc662a18";


@interface GenerateUserSig : NSObject

/**
 * 计算 UserSig 签名
 *
 * 函数内部使用 HMAC-SHA256 非对称加密算法，对 SDKAPPID、userId 和 EXPIRETIME 进行加密。
 * 文档：https://cloud.tencent.com/document/product/647/17275#Server
 */

+ (NSString *)genTestUserSig:(NSString *)identifier;

@end

NS_ASSUME_NONNULL_END
