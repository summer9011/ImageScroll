//
//  ViewController.m
//  imageScroll
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"

#import "ImageScrollView.h"

@interface ViewController () <ImageScrollDelegate>

@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) ImageScrollView *imageScroll;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"图片浏览器";
    
    self.images = @[
                        @"http://www.dabaoku.com/sucaidatu/dongwu/dongwushijie/027503.JPG",
                        @"http://bbsimg.qianlong.com/data/attachment/forum/201410/08/134537d565rdmar6cirrdc.jpg",
                        @"http://pic49.nipic.com/file/20140928/14386371_184318185000_2.jpg",
                        @"http://funpicimg.loveinhere.com/1008/1/p_1996.jpg",
                        @"http://pic49.nipic.com/file/20140928/14386371_202320086000_2.jpg",
                        @"http://pic49.nipic.com/file/20140928/14386371_201059337000_2.jpg",
                        @"http://pic49.nipic.com/file/20140928/14386371_215730739000_2.jpg",
                        @"http://img3.3lian.com/2014/c1/23/d/72.jpg",
                        @"http://www.dabaoku.com/sucaidatu/dongwu/dongwushijie/091263.JPG",
                        @"http://h.hiphotos.baidu.com/image/pic/item/0ff41bd5ad6eddc42664dff13bdbb6fd5266333c.jpg",
                        @"http://b.hiphotos.baidu.com/image/pic/item/d0c8a786c9177f3e2675b00a72cf3bc79f3d5677.jpg",
                        @"http://d.hiphotos.baidu.com/image/pic/item/faf2b2119313b07ed9312adf08d7912396dd8c5c.jpg",
                        @"http://g.hiphotos.baidu.com/image/pic/item/b2de9c82d158ccbf3a66cfed1dd8bc3eb035410a.jpg",
                        @"http://d.hiphotos.baidu.com/image/pic/item/fc1f4134970a304e468eda2dd5c8a786c8175cbc.jpg",
                        @"http://d.hiphotos.baidu.com/image/pic/item/00e93901213fb80e505f1b0032d12f2eb838945e.jpg"
                        ];
    
    self.imageScroll = [[ImageScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds)) imageIndex:0];
    self.imageScroll.imageScrollDelegate = self;
    
    [self.view addSubview:self.imageScroll];
}

#pragma mark - ImageScrollDelegate

- (NSUInteger)numberOfItems {
    return self.images.count;
}

- (NSString *)imageURLForIndex:(NSUInteger)index {
    return self.images[index];
}

- (void)didSingleTapImageView:(UIImageView *)imageView index:(NSUInteger)index {
    
}

- (void)didDoubleTapImageView:(UIImageView *)imageView index:(NSUInteger)index zoom:(BOOL)isZoomUp {
    
}

- (void)didChangeImageView:(NSUInteger)index {
    
}

@end
