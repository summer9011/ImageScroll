//
//  PicHandlerController.m
//  imageScroll
//
//  Created by apple on 15/8/26.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "PicHandlerController.h"

@interface PicHandlerController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PicHandlerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.title = @"贴图";
    
    [self initScrollView];
}

- (IBAction)addPic:(id)sender {
    self.scrollView.scrollEnabled = NO;
    
    UIImage *picImage = [UIImage imageNamed:@"pic"];
    
    UIImageView *touchImageView = [[UIImageView alloc] initWithImage:picImage];
    
    touchImageView.frame = CGRectMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame)/2.f - picImage.size.width/2.f, CGRectGetHeight(self.scrollView.frame)/2.f - picImage.size.height/2.f, picImage.size.width, picImage.size.height);
    
    [self.scrollView addSubview:touchImageView];
}

- (void)initScrollView {
    CGRect bounds = [UIScreen mainScreen].bounds;
    
    CGFloat scrollViewWidth = CGRectGetWidth(bounds);
    CGFloat scrollViewHeight = CGRectGetHeight(bounds) - 20 - 44;
    
    self.scrollView.frame = CGRectMake(0, 64, scrollViewWidth, scrollViewHeight);
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.userInteractionEnabled = YES;
    
    CGFloat boundP = scrollViewWidth/scrollViewHeight;
    CGFloat imageP = image.size.width/image.size.height;
    
    CGFloat width;
    CGFloat height;
    if (boundP > imageP) {
        width = scrollViewWidth;
        height = width / imageP;
    } else {
        height = scrollViewHeight;
        width = height * imageP;
    }
    
    imageView.frame = CGRectMake(0, 0, width, height);
    
    [self.scrollView addSubview:imageView];
    self.scrollView.contentSize = CGSizeMake(width, height);
    
    self.scrollView.minimumZoomScale = 1.f;
    self.scrollView.maximumZoomScale = 3.f;
    
    self.scrollView.zoomScale = 1.f;
    
    [self.scrollView setContentOffset:CGPointMake((width - scrollViewWidth)/2.f, (height - scrollViewHeight)/2.f) animated:YES];
}

@end
