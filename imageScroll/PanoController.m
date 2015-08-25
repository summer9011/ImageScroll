//
//  PanoController.m
//  imageScroll
//
//  Created by 赵立波 on 15/8/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PanoController.h"

@interface PanoController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, strong) NSArray *panoArr;
@property (nonatomic, strong) NSString *currentScene;

@end

@implementation PanoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.panoArr = @[
                     @"http://localhost/pano/panos/tour.xml"
                     ];
    
    NSURL *url = [NSURL URLWithString:@"http://localhost/pano/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goPano:(id)sender {
    UIBarButtonItem *buttonItem = (UIBarButtonItem *)sender;
    
    NSString *scene = [NSString stringWithFormat:@"scene%ld", buttonItem.tag];
    if (![scene isEqualToString:self.currentScene]) {
        self.currentScene = scene;
        [self loadScene];
    }
    
}

- (IBAction)reloadPano:(id)sender {
    NSString *loadScene = [NSString stringWithFormat:@"getSceneData('%@')", self.currentScene];
    [self.webView stringByEvaluatingJavaScriptFromString:loadScene];
}

//进入场景
- (void)loadScene {
    NSString *loadScene = [NSString stringWithFormat:@"goScene('%@')", self.currentScene];
    [self.webView stringByEvaluatingJavaScriptFromString:loadScene];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *fragment = request.URL.fragment;
    NSLog(@"%@", fragment);
    
    if ([fragment isEqualToString:@"ready"]) {
        NSString *loadPano = [NSString stringWithFormat:@"goPano('%@')", self.panoArr[0]];
        [self.webView stringByEvaluatingJavaScriptFromString:loadPano];
        
        self.currentScene = @"scene1";
        [self loadScene];
    }
    
    if ([fragment isEqualToString:@"complete"]) {
        NSLog(@"完成");
    }
    
    if ([fragment isEqualToString:@"error"]) {
        NSLog(@"全景加载失败");
    }
    
    return YES;
}

@end
