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

@end

@implementation PanoController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.100/pano/"];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    [self.webView loadRequest:request];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextPano:(id)sender {
    NSLog(@"下一个全景");
}

- (IBAction)reloadPano:(id)sender {
    NSLog(@"重新加载");
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"absoluteString %@, fragment %@", request.URL.absoluteString, request.URL.fragment);
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

@end
