//
//  HQLAuthWebViewController.h
//  HQLTwitchBroadcast
//
//  Created by 何启亮 on 2017/11/7.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HQLAuthWebViewController : UIViewController

- (instancetype)initWithURL:(NSString *)URL callbackURL:(NSString *)callbackURL completeHandler:(void(^)(NSURL *callbackURL, NSError *error))completeHandler;

+ (void)cleanCach;

@end
