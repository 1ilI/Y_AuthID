//
//  Y_AuthID.h
//  AuthID
//
//  Created by Yue on 2018/1/11.
//  Copyright © 2018年 Yue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>

typedef enum : NSUInteger {
    //  当前设备不支持AuthID
    Y_AuthIDTypeNotSupport = 0,
    
    // AuthID 验证成功
    Y_AuthIDTypeSuccess,
    
    // AuthID 验证失败
    Y_AuthIDTypeFail,
    
    // AuthID 被用户手动取消
    Y_AuthIDTypeUserCancel,
    
    // 用户不使用AuthID,选择手动输入密码
    Y_AuthIDTypeInputPassword,
    
    // AuthID 被系统取消 (如遇到来电,锁屏,按了Home键等)
    Y_AuthIDTypeSystemCancel,
    
    // AuthID 无法启动,因为用户没有设置密码
    Y_AuthIDTypePasswordNotSet,
    
    // AuthID 无法启动,因为用户没有设置AuthID
    Y_AuthIDTypeAuthIDNotSet,
    
    // AuthID 无效
    Y_AuthIDTypeAuthIDNotAvailable,
    
    // AuthID 被锁定(连续多次验证AuthID失败,系统需要用户手动输入密码)
    Y_AuthIDTypeAuthIDLockout,
    
    // 当前软件被挂起并取消了授权 (如App进入了后台等)
    Y_AuthIDTypeAppCancel,
    
    // 当前软件被挂起并取消了授权 (LAContext对象无效)
    Y_AuthIDTypeInvalidContext,
    
    // 系统版本不支持AuthID (必须高于iOS 8.0才能使用)
    Y_AuthIDTypeVersionNotSupport
    
} Y_AuthIDType;


/**
 指纹解锁 校验回调
 
 @param authIDType 返回类型Y_AuthIDType
 @param error 错误error
 @param message 返回文本信息
 */
typedef void(^AuthIDCheckResult)(Y_AuthIDType authIDType, NSError *error, NSString *message);

@interface Y_AuthID : NSObject


/**
 判断设备是否支持身份验证

 @return YES：支持、 NO：不支持
 */
+ (BOOL)deviceCanSupport;

/**
 判断该设备是否支持FaceID

 @return YES：支持、 NO：不支持
 */
+ (BOOL)canSupportFaceID;

/**
 启动AuthID进行身份验证

 @param hasInput 默认为NO，验证失败时显示 取消; 当为YES时，验证失败时显示 取消|输入密码
 @param needUnlock 默认为NO，当为YES时，若失败次数过多，生物验证锁定时，弹出输入系统密码以解锁
 @param resutl 指纹解锁 校验回调
 */
+ (void)showAuthIDHasInputPassword:(BOOL)hasInput needUnlock:(BOOL)needUnlock result:(AuthIDCheckResult )resutl;

@end
