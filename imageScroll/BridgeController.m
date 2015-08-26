//
//  BridgeController.m
//  imageScroll
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "BridgeController.h"

#import "WebViewJavascriptBridge.h"

@interface BridgeController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) WebViewJavascriptBridge *bridge;

@end

@implementation BridgeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Bridge";
    
    NSURL *url = [NSURL URLWithString:@"http://localhost/bridge/"];
    NSURLRequest *reqeust = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:reqeust];
    
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"received from js %@", data);
    }];
    
    [self.bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"registerHandler from js %@", data);
        
        responseCallback(@"回调数据给JS");
    }];
}

- (void)dealloc {
    self.webView.delegate = nil;
    self.webView = nil;
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (IBAction)sendDataToJS:(id)sender {
    [self.bridge send:@"我从OC来" responseCallback:^(id responseData) {
        NSLog(@"回调 %@", responseData);
    }];
}

- (IBAction)sendDataToJSRegisterFunction:(id)sender {
    [self.bridge callHandler:@"testJavascriptHandler" data:@"从OC来" responseCallback:^(id responseData) {
        NSLog(@"testJavascriptHandler %@", responseData);
    }];
}

@end
