//
//  TwitchAppFetcherAuthorization.m
//  HQLTwitchBroadcast
//
//  Created by 何启亮 on 2017/11/7.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import "TwitchAppFetcherAuthorization.h"

@implementation TwitchAppFetcherAuthorization

- (instancetype)init {
    if (self = [super init]) {
        self.updateTime = [NSDate date];
    }
    return self;
}

- (BOOL)canAppAuthorization {
    NSInteger expires = [self.app_accessToken_expires_in integerValue];
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:self.app_accsssToken_updateTime];
    return (duration < expires);
}

- (BOOL)canAuthorization {
    NSInteger expires = [self.expires_in integerValue];
    NSInteger duration = [[NSDate date] timeIntervalSinceDate:self.updateTime];
    return (duration < expires);
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.code forKey:@"hql.twitchCode"];
    [aCoder encodeObject:self.refreshToken forKey:@"hql.twitchRefreshToken"];
    [aCoder encodeObject:self.accessToken forKey:@"hql.twitchAccessToken"];
    [aCoder encodeObject:self.updateTime forKey:@"hql.twitchUpdateTime"];
    [aCoder encodeObject:self.expires_in forKey:@"hql.twitchExpires_in"];
    [aCoder encodeObject:self.scopes forKey:@"hql.twitchScopes"];
    
    [aCoder encodeObject:self.app_accessToken forKey:@"hql.twitch_app_accessToken"];
    [aCoder encodeObject:self.app_accessToken_scopes forKey:@"hql.twitch_app_accessToken_scopes"];
    [aCoder encodeObject:self.app_accessToken_expires_in forKey:@"hql.twitch_app_accessToken_expires_in"];
    [aCoder encodeObject:self.app_accsssToken_updateTime forKey:@"hql.twitch_app_accessToken_updateTime"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.code = [aDecoder decodeObjectForKey:@"hql.twitchCode"];
        self.refreshToken = [aDecoder decodeObjectForKey:@"hql.twitchRefreshToken"];
        self.accessToken = [aDecoder decodeObjectForKey:@"hql.twitchAccessToken"];
        self.updateTime = [aDecoder decodeObjectForKey:@"hql.twitchUpdateTime"];
        self.expires_in = [aDecoder decodeObjectForKey:@"hql.twitchExpires_in"];
        self.scopes = [aDecoder decodeObjectForKey:@"hql.twitchScopes"];
        
        self.app_accessToken = [aDecoder decodeObjectForKey:@"hql.twitch_app_accessToken"];
        self.app_accessToken_scopes = [aDecoder decodeObjectForKey:@"hql.twitch_app_accessToken_scopes"];
        self.app_accessToken_expires_in = [aDecoder decodeObjectForKey:@"hql.twitch_app_accessToken_expires_in"];
        self.app_accsssToken_updateTime = [aDecoder decodeObjectForKey:@"hql.twitch_app_accessToken_updateTime"];
    }
    return self;
}

@end
