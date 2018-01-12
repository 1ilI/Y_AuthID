//
//  Y_AuthID.m
//  AuthID
//
//  Created by Yue on 2018/1/11.
//  Copyright © 2018年 Yue. All rights reserved.
//

#import "Y_AuthID.h"
#import <UIKit/UIKit.h>

#define IPHONEX_SIZE    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// 操作系统版本号
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

#define Result_Get_Main_Queue(__AuthIDCheckResult__)   dispatch_async(dispatch_get_main_queue(), ^{\
__AuthIDCheckResult__;\
});

@implementation Y_AuthID

+ (void)showAuthIDHasInputPassword:(BOOL)hasInput needUnlock:(BOOL)needUnlock result:(AuthIDCheckResult )resutl {
    if (NSFoundationVersionNumber < NSFoundationVersionNumber_iOS_8_0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resutl(Y_AuthIDTypeNotSupport,nil, @"iOS 8.0以下不支持生物验证");
        });
        return;
    }
    
    LAContext *context = [LAContext new];
    //验证失败时显示   取消 | 输入密码
    //localizedFallbackTitle 为@""时，仅显示 取消
    context.localizedFallbackTitle = hasInput ? nil : @"";
    
    // LAPolicyDeviceOwnerAuthenticationWithBiometrics: 用TouchID/FaceID 生物验证
    // LAPolicyDeviceOwnerAuthentication: 用TouchID/FaceID或密码验证, 当生物验证锁定后, 弹出输入密码界面
    NSError *error = nil;
    //是否支付验证
    BOOL support = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (support) {
        NSString *authType = IPHONEX_SIZE ? @"FaceID" : @"TouchID";
        NSString *localizedReason = IPHONEX_SIZE ? @"面容ID" : @"轻触Home键验证已有手机指纹";
        NSString *localizedReason2 = [authType stringByAppendingString:@"验证失败,系统需要您手动输入密码"];
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
            //验证成功
            if (success) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    NSString *msg = [authType stringByAppendingString:@"验证成功"];
                    resutl(Y_AuthIDTypeSuccess, error, msg);
                });
                return ;
            }
            //验证失败
            else if (error) {
                NSString *msg = @"";
                switch (error.code) {
                    case LAErrorAuthenticationFailed: {
                        msg = [authType stringByAppendingString:@"验证失败"];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeFail, error, msg));
                    }
                        break;
                        
                    case LAErrorUserCancel: {
                        msg = [authType stringByAppendingString:@"被用户手动取消"];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeUserCancel, error, msg));
                    }
                        break;
                        
                    case LAErrorUserFallback: {
                        msg = [NSString stringWithFormat:@"用户不使用%@,选择手动输入密码",authType];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeInputPassword, error, msg));
                    }
                        break;
                        
                    case LAErrorSystemCancel: {
                        msg = [authType stringByAppendingString:@"被系统取消 (如遇到来电,锁屏,按了Home键等)"];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeSystemCancel, error, msg));
                    }
                        break;
                        
                    case LAErrorPasscodeNotSet: {
                        msg = [authType stringByAppendingString:@"无法启动,因为用户没有设置密码"];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypePasswordNotSet, error, msg));
                    }
                        break;
                        
                    case kLAErrorTouchIDNotEnrolled: {
                        msg = [NSString stringWithFormat:@"%@无法启动,因为用户没有设置%@",authType,authType];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeAuthIDNotSet, error, msg));
                    }
                        break;
                        
                    case kLAErrorTouchIDNotAvailable: {
                        msg = [authType stringByAppendingString:@"无效"];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeAuthIDNotAvailable, error, msg));
                    }
                        break;
                        
                        
                        if (IOS_VERSION >= 9.0) {
                        case kLAErrorTouchIDLockout: {
                            msg = [authType stringByAppendingString:@"被锁定(多次验证失败,系统需要用户手动输入密码)"];
                            Result_Get_Main_Queue(resutl(Y_AuthIDTypeAuthIDLockout, error, msg));
                            if (needUnlock) {
                                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:localizedReason2 reply:^(BOOL success, NSError * _Nullable error) {}];
                            }
                        }
                            break;
                        case LAErrorAppCancel: {
                            msg = @"当前软件被挂起并取消了授权 (如App进入了后台等)";
                            Result_Get_Main_Queue(resutl(Y_AuthIDTypeAppCancel, error, msg));
                            if (needUnlock) {
                                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:localizedReason2 reply:^(BOOL success, NSError * _Nullable error) {}];
                            }
                        }
                            break;
                        case LAErrorInvalidContext: {
                            msg = @"当前软件被挂起并取消了授权 (LAContext对象无效)";
                            Result_Get_Main_Queue(resutl(Y_AuthIDTypeInvalidContext, error, msg));
                            if (needUnlock) {
                                [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:localizedReason2 reply:^(BOOL success, NSError * _Nullable error) {}];
                            }
                        }
                            break;
                        }
                        
                    default:{
                        msg = [authType stringByAppendingString:@"验证 失败"];
                        Result_Get_Main_Queue(resutl(Y_AuthIDTypeFail, error, msg));
                        if (needUnlock) {
                            [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:localizedReason2 reply:^(BOOL success, NSError * _Nullable error) {}];
                        }
                    }
                        break;
                }
            }
        }];
    }
    else {
        Result_Get_Main_Queue(resutl(Y_AuthIDTypeNotSupport,nil,@"暂不支持验证（也有可能是多次验证失败导致）"));
    }
}


@end
