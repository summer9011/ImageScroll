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

/**
 *  获取图片总数
 *
 *  @return 图片总数
 */
- (NSUInteger)numberOfItems;

/**
 *  获取图片
 *
 *  @param index 图片下标
 *
 *  @return 图片路径
 */
- (NSString *)imageURLForIndex:(NSUInteger)index;

@optional

/**
 *  单击图片
 *
 *  @param imageView 点击的图片
 *  @param index     图片下标
 */
- (void)didSingleTapImageView:(UIImageView *)imageView index:(NSUInteger)index;

/**
 *  双击缩放图片
 *
 *  @param imageView 双击的图片
 *  @param index     图片下标
 *  @param isZoomUp  是否为放大
 */
- (void)didDoubleTapImageView:(UIImageView *)imageView index:(NSUInteger)index zoomUp:(BOOL)isZoomUp;

/**
 *  切换图片
 *
 *  @param index 图片下标
 */
- (void)didChangeImageView:(NSUInteger)index;

@end

@interface ImageScrollView : UIView

@property (nonatomic, weak) id<ImageScrollDelegate> imageScrollDelegate;

@property (nonatomic, assign) NSUInteger imageIndex;

/**
 *  Init
 *
 *  @param frame View的frame
 *
 *  @return ImageScrollView
 */
- (id)initWithFrame:(CGRect)frame;

/**
 *  Init
 *
 *  @param frame View的frame
 *  @param index 当前图片的下标
 *
 *  @return ImageScrollView
 */
- (id)initWithFrame:(CGRect)frame imageIndex:(NSUInteger)index;

@end
