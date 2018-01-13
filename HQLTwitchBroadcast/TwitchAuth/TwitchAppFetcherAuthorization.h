//
//  TwitchAppFetcherAuthorization.h
//  HQLTwitchBroadcast
//
//  Created by 何启亮 on 2017/11/7.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitchAppFetcherAuthorization : NSObject <NSCoding>

@property (nonatomic, copy) NSString *code; // Authorization code
@property (nonatomic, copy) NSString *refreshToken; // refresh token --- 暂时没用
@property (nonatomic, copy) NSString *accessToken; // access token
@property (nonatomic, strong) NSDate *updateTime; // 更新时间
@property (nonatomic, copy) NSString *expires_in; // 过期时间 --- access token
@property (nonatomic, strong) NSDictionary *scopes; // 权限

@property (nonatomic, copy) NSString *app_accessToken; // app token
@property (nonatomic, copy) NSString *app_accessToken_expires_in; // app accsee token 过期时间
@property (nonatomic, strong) NSDate *app_accsssToken_updateTime; // app assess token 更新时间
@property (nonatomic, strong) NSDictionary *app_accessToken_scopes; // 权限

- (BOOL)canAuthorization;
- (BOOL)canAppAuthorization;

@end
