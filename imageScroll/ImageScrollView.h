//
//  ImageScrollView.h
//  imageScroll
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageScrollDelegate <NSObject>

@required
//获取图片总数
- (NSUInteger)numberOfItems;

//获取图片
- (NSString *)imageURLForIndex:(NSUInteger)index;

@optional
//单击图片
- (void)didSingleTapImageView:(UIImageView *)imageView index:(NSUInteger)index;

//双击缩放图片
- (void)didDoubleTapImageView:(UIImageView *)imageView index:(NSUInteger)index zoomUp:(BOOL)isZoomUp;

//切换图片
- (void)didChangeImageView:(NSUInteger)index;

@end

@interface ImageScrollView : UIView

@property (nonatomic, weak) id<ImageScrollDelegate> imageScrollDelegate;

@property (nonatomic, assign) NSUInteger imageIndex;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithFrame:(CGRect)frame imageIndex:(NSUInteger)index;

@end
