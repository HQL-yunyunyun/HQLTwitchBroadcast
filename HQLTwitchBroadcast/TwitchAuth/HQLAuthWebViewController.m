//
//  HQLAuthWebViewController.m
//  HQLTwitchBroadcast
//
//  Created by 何启亮 on 2017/11/7.
//  Copyright © 2017年 HQL. All rights reserved.
//

#import "HQLAuthWebViewController.h"
#import <WebKit/WebKit.h>

@interface HQLAuthWebViewController () <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) UIView *navigationView;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) WKWebView *webView;

@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong) NSTimer *timer;

// ----
@property (nonatomic, copy) NSString *loadURL;
@property (nonatomic, copy) void(^completeHandler)(NSURL *callbackURL, NSError *error);
@property (nonatomic, copy) NSString *callbackURL;

@end

@implementation HQLAuthWebViewController {
    BOOL isShowProgress;
    double progress;
}

- (instancetype)initWithURL:(NSString *)URL callbackURL:(NSString *)callbackURL completeHandler:(void (^)(NSURL *, NSError *))completeHandler {
    if (self = [super init]) {
        self.callbackURL = callbackURL;
        self.loadURL = URL;
        self.completeHandler = completeHandler;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
    
    self.titleLabel.text = self.loadURL;
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loadURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.loadURL]];
    [self.webView loadRequest:request];
}

- (void)dealloc {
    NSLog(@"dealloc ---> %@", NSStringFromClass([self class]));
}

#pragma mark - prepare UI

- (void)prepareUI {
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 64)];
    [self.navigationView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.navigationView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 63.5, screenWidth, 0.5)];
    lineView.backgroundColor = [UIColor blackColor];
    [self.navigationView addSubview:lineView];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeSystem];
    [done setTitle:@"done" forState:UIControlStateNormal];
    [done setFrame:CGRectMake(5, ((44 - 30) * 0.5) + 20, 50, 30)];
    [self.navigationView addSubview:done];
    self.closeButton = done;
    [done addTarget:self action:@selector(doneButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *refresh = [UIButton buttonWithType:UIButtonTypeSystem];
    [refresh setTitle:@"refresh" forState:UIControlStateNormal];
    [refresh setFrame:CGRectMake(screenWidth - 5 - 50, done.frame.origin.y, 50, 30)];
    [self.navigationView addSubview:refresh];
    self.refreshButton = refresh;
    [refresh addTarget:self action:@selector(refreshButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(done.frame) + 5, 20 + 5, refresh.frame.origin.x - 10 - CGRectGetMaxX(done.frame) , 44 - 10)];
    titleView.layer.borderColor = [UIColor blackColor].CGColor;
    titleView.layer.borderWidth = 0.5;
    [self.navigationView addSubview:titleView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, titleView.frame.size.width - 10, titleView.frame.size.height - 10)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setFont:[UIFont systemFontOfSize:14]];
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64)];
    webView.navigationDelegate = self;
    webView.UIDelegate = self;
    [self.view addSubview:webView];
    self.webView = webView;
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    [progressView setFrame:CGRectMake(0, 64, screenWidth, progressView.frame.size.height)];
    [self.view addSubview:progressView];
    self.progressView = progressView;
}

#pragma mark - event

- (void)dismissViewController {
    
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)doneButtonDidClick:(UIButton *)button {
    self.completeHandler ? self.completeHandler(nil, [NSError errorWithDomain:@"cancel" code:-1 userInfo:nil]) : nil;
    [self dismissViewController];
}

- (void)refreshButtonDidClick:(UIButton *)button {
    [self.webView reload];
}

-(void)timerCallback {
    if (!isShowProgress) {
        if (self.progressView.progress >= 1) {
            self.progressView.hidden = YES;
            [self.timer invalidate];
        }
        else {
            self.progressView.progress += 0.1;
        }
    }
    else {
        self.progressView.progress += 0.05;
        if (self.progressView.progress >= 0.95) {
            self.progressView.progress = 0.95;
        }
    }
}

- (void)startTimer {
    self.progressView.progress = 0;
    isShowProgress = YES;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01667 target:self selector:@selector(timerCallback) userInfo:nil repeats:YES];
}

- (void)setupURL:(NSURL *)url {
    self.titleLabel.text = url.absoluteString;
    [self startTimer];
    
    NSString *urlString = url.absoluteString;
    NSRange range = [urlString rangeOfString:self.callbackURL];
    if (range.location != NSNotFound && range.length == self.callbackURL.length && range.location == 0) {
        self.completeHandler ? self.completeHandler(url, nil) : nil;
        [self dismissViewController];
    }
}

+ (void)cleanCach {
    CGFloat system = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (system >= 9.0) {
        NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
        }];
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
    
}

#pragma mark - web view delegate

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self setupURL:webView.URL];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation {
    [self setupURL:webView.URL];
}

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation {
    isShowProgress = NO;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    isShowProgress = NO;
}

@end
