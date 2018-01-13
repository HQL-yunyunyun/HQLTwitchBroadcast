//
//  ViewController.m
//  HQLTwitchBroadcast
//
//  Created by 何启亮 on 2017/11/2.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import "ViewController.h"
#import "HQLTwitchOAuth.h"

@interface ViewController ()

@property (nonatomic, strong) HQLTwitchOAuth *twitchOAuth;

@property (nonatomic, strong) TwitchAppFetcherAuthorization *authorization;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.twitchOAuth = [[HQLTwitchOAuth alloc] init];
}

- (IBAction)open:(id)sender {
//    NSString *url = [NSString stringWithFormat:authUrl, twitchClientID, twitchRedirectUri, @"user:edit%20openid%20user:read:email"];
////    SFSafariViewController *viewController = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url]];
//    HQLWebKitController *viewController = [[HQLWebKitController alloc] init];
//    viewController.url = url;
//    [self presentViewController:viewController animated:YES completion:^{
//
//    }];
    
//    NSString *code = @"df7j5eewhwb6br9ykw97582tr099fu";
//    NSString *tokenURL = [NSString stringWithFormat:tokenUrl, twitchClientID, twitchClientSecret, code, twitchRedirectUri];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:tokenURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
//        NSLog(@"response object %@", responseObject);
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"error %@", error);
//    }];
    
//    HQLAuthWebViewController *controller = [[HQLAuthWebViewController alloc] init];
//    [self presentViewController:controller animated:YES completion:^{
//
//    }];
    
    [self.twitchOAuth doTwitchAuthWithPresentController:self thenHandler:^(TwitchAppFetcherAuthorization *authorization, NSError *error) {
//        self.authorization = authorization;
    }];
    
}
- (IBAction)userInfo:(id)sender {
    [self.twitchOAuth fetchUserInfoWithPresentController:self completeHandler:^(NSDictionary *userInfo, NSError *error) {
        
    }];
}
- (IBAction)refreshToken:(id)sender {
    [self.twitchOAuth refreshTokenWithCompleteHandler:^(TwitchAppFetcherAuthorization *authorization, NSError *error) {
//        self.authorization = authorization;
    }];
}
- (IBAction)revokeToken:(id)sender {
//    [self.twitchOAuth revokeAccessTokenWithToken:self.twitchOAuth.authorization.accessToken completeHandler:^(NSError *error) {
//
//    }];
    
//    [self.twitchOAuth cleanAuthCache];
    
    [self.twitchOAuth fetchTwitchBroadcastStatusWithPresentController:self completeHandler:^(TwitchBroadcastStatus broadcastStatus, NSDictionary *streamDict, NSError *error) {
        
    }];
    
}
- (IBAction)broadcastURL:(id)sender {
    [self.twitchOAuth fetchTwitchBroadcastURLWithPresentController:self completeHandler:^(NSString *broadcastURL, NSError *error) {
        
    }];
}
- (IBAction)updateStatus:(id)sender {
    
    [self.twitchOAuth fetchServer:self];
    
//    [self.twitchOAuth updateTwitchChannelStatusWithPresentController:self status:@"这是一个测试" completeHandler:^(NSError *error) {
//
//    }];
    
}
- (IBAction)connectToSocket:(id)sender {
    [self.twitchOAuth autoReceiveChannelChatWithPresentController:self];
}

@end
