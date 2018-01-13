//
//  HQLTwitchOAuth.h
//  HQLTwitchBroadcast
//
//  Created by 何启亮 on 2017/11/2.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitchAppFetcherAuthorization.h"

typedef NS_ENUM(NSInteger, TwitchBroadcastStatus) {
    TwitchBroadcastStatus_off_line = 0,
    TwitchBroadcastStatus_live,
};

static NSString *const TwitchAuthErrorDoMain = @"coolpixel.twitch.broadcastAuthorization.error.doMain";

static NSString *const TwitchAuthorizationDidChangeNotification = @"hql.TwitchAuthorizationDidChangeNotification";
static NSString *const TwitchAuthorizationDidChangeNotificationAuthorizationKey = @"hql.TwitchAuthorizationDidChangeNotificationAuthorizationKey";

@protocol HQLTwitchOAuthDelegate <NSObject>

//- (void)twitchBroadcastStatusDidChange:(TwitchBroadcastStatus)broadcastStatus;

// 收到 liveMessage --- 格式: <name:message>
- (void)twitchDidReceiveLiveMessage:(NSArray <NSString *>*)liveMessages;

// liveMessage 收到 error
- (void)twitchDidReceiveLiveMessageError:(NSError *)error;

@end

typedef void(^TwitchOAuthCompleteHandler)(TwitchAppFetcherAuthorization *authorization, NSError *error);

@interface HQLTwitchOAuth : NSObject

@property (assign, nonatomic) id <HQLTwitchOAuthDelegate>delegate;
@property (strong, nonatomic, readonly) TwitchAppFetcherAuthorization *authorization;

- (instancetype)initWithAuthorization:(TwitchAppFetcherAuthorization *)authorization;

// --- mehtod

// 授权
- (void)doTwitchAuthWithPresentController:(UIViewController *)controller thenHandler:(TwitchOAuthCompleteHandler)handler;

// 刷新token
- (void)refreshTokenWithCompleteHandler:(TwitchOAuthCompleteHandler)handler;

// revoke token
- (void)revokeAccessTokenWithToken:(NSString *)token completeHandler:(void(^)(NSError *error))handler;

// app auth
- (void)doTwitchAppAuthWithCompleteHandler:(TwitchOAuthCompleteHandler)handler;

// 获取Broadcast地址
- (void)fetchTwitchBroadcastURLWithPresentController:(UIViewController *)controller completeHandler:(void(^)(NSString *broadcastURL, NSError *error))completeHandler;

// 获取直播状态
- (void)fetchTwitchBroadcastStatusWithPresentController:(UIViewController *)controller completeHandler:(void(^)(TwitchBroadcastStatus broadcastStatus, NSDictionary *streamDict, NSError *error))handler;

// 获取用户信息
- (void)fetchUserInfoWithPresentController:(UIViewController *)controller completeHandler:(void(^)(NSDictionary *userInfo, NSError *error))handler;

// 这里的status相当于 直播的title
- (void)updateTwitchChannelStatusWithPresentController:(UIViewController *)controller status:(NSString *)status completeHandler:(void(^)(NSError *error))handler;

// 清除缓存
- (void)cleanAuthCache;

// 自动连接到chat服务器
- (void)autoReceiveChannelChatWithPresentController:(UIViewController *)controller;
// 停止连接
- (void)stopReceiveChannelChat;

- (void)fetchServer:(UIViewController *)controller;

@end
