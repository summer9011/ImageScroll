//
//  ImageScrollView.m
//  imageScroll
//
//  Created by apple on 15/8/20.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ImageScrollView.h"

#import "UIImageView+WebCache.h"
#import "UIImage+GIF.h"

@interface ImageScrollView () <UIScrollViewDelegate>

@property (nonatomic, assign) CGFloat oldOffsetX;

@property (nonatomic, strong) UIView *imageScrollView;
@property (nonatomic, weak) UIImageView *backgroundImageView;
@property (nonatomic, weak) UIScrollView *contentScrollView;

@end

@implementation ImageScrollView

#pragma mark - Init

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + 20, frame.size.height)];
    
    if (self) {
        self.imageIndex = 0;
        [self initSelfView];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame imageIndex:(NSUInteger)index {
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width + 20, frame.size.height)];
    
    if (self) {
        self.imageIndex = index;
        [self initSelfView];
    }
    
    return self;
}

- (void)initSelfView {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"ImageScrollView" owner:nil options:nil];
    self.imageScrollView = nibViews[0];
    self.imageScrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
    self.backgroundImageView = self.imageScrollView.subviews[0];
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    effectView.frame = self.imageScrollView.frame;
    [self.backgroundImageView addSubview:effectView];
    
    self.contentScrollView = self.imageScrollView.subviews[1];
    self.contentScrollView.frame = self.imageScrollView.frame;
    self.contentScrollView.delegate = self;
    
    [self addSubview:self.imageScrollView];
}

#pragma mark - Setter

- (void)setImageScrollDelegate:(id<ImageScrollDelegate>)imageScrollDelegate {
    _imageScrollDelegate = imageScrollDelegate;
    
    [self setContents];
    [self changeBackgroundImageView:self.imageIndex];
    [self loadImageView];
}

#pragma mark - Private Method

- (void)setContents {
    NSUInteger imageCount = [self.imageScrollDelegate numberOfItems];
    
    for (int i = 0; i < imageCount; i ++) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame)*i, 0, CGRectGetWidth(self.frame) - 20, CGRectGetHeight(self.frame))];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.delegate = self;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapOnImageView:)];
        [imageView addGestureRecognizer:singleTap];
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapOnImageView:)];
        doubleTap.numberOfTapsRequired = 2;
        [imageView addGestureRecognizer:doubleTap];
        
        [scrollView addSubview:imageView];
        
        [self.contentScrollView addSubview:scrollView];
    }
    
    self.contentScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.frame) * imageCount, CGRectGetHeight(self.frame));
    self.contentScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*self.imageIndex, 0);
}

- (void)changeBackgroundImageView:(NSUInteger)index {
    NSUInteger imageCount = [self.imageScrollDelegate numberOfItems];

    if (index <= imageCount - 1) {
        NSURL *imageURL = [NSURL URLWithString:[self.imageScrollDelegate imageURLForIndex:index]];
        
        [UIView animateWithDuration:0.2 animations:^{
            self.backgroundImageView.alpha = 0.5;
        } completion:^(BOOL finished) {
            [self.backgroundImageView sd_setImageWithURL:imageURL completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [UIView animateWithDuration:0.2 animations:^{
                    self.backgroundImageView.alpha = 1.f;
                }];
            }];
        }];
    }
}

- (void)loadImageView {
    [self setImageContentsWithIndex:self.imageIndex];
    
    //设置左侧的图片
    NSInteger leftIndex = self.imageIndex - 1;
    if (leftIndex >= 0) {
        [self setImageContentsWithIndex:leftIndex];
    }
    
    //设置右侧的图片
    NSInteger rightIndex = self.imageIndex + 1;
    if (rightIndex <= [self.imageScrollDelegate numberOfItems] - 1) {
        [self setImageContentsWithIndex:rightIndex];
    }
}

- (void)setImageContentsWithIndex:(NSUInteger)index {
    NSUInteger imageCount = [self.imageScrollDelegate numberOfItems];
    
    if (index <= imageCount - 1) {
        NSURL *imageURL = [NSURL URLWithString:[self.imageScrollDelegate imageURLForIndex:index]];
        
        UIScrollView *imageScroll = self.contentScrollView.subviews[index];
        UIImageView *imageView = imageScroll.subviews[0];
        
        imageView.contentMode = UIViewContentModeCenter;
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(imageScroll.frame), CGRectGetHeight(imageScroll.frame));
        imageScroll.minimumZoomScale = 1.f;
        imageScroll.maximumZoomScale = 1.f;
        [imageScroll setZoomScale:1.f];
        
        imageScroll.scrollEnabled = NO;
        
        UIImage *gifImage = [UIImage sd_animatedGIFNamed:@"loading"];
        [imageView sd_setImageWithURL:imageURL placeholderImage:gifImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (error == nil) {
                [self setImageScroll:imageScroll With:image];
            }
        }];
    }
    
}

- (void)setImageScroll:(UIScrollView *)scrollView With:(UIImage *)image {
    UIImageView *imageView = scrollView.subviews[0];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGSize imageSize = imageView.image.size;
    CGSize viewSize = self.frame.size;
    
    double imageP = imageSize.width/imageSize.height;
    double viewP = viewSize.width/viewSize.height;
    
    CGFloat minScale = 1.f;
    if (imageP > viewP) {
        minScale = viewSize.width/imageSize.width;
    } else {
        minScale = viewSize.height/imageSize.height;
    }
    
    scrollView.minimumZoomScale = minScale;
    scrollView.maximumZoomScale = minScale*2;
    [scrollView setZoomScale:minScale];
}

#pragma mark - UIGestureRecognizer

- (void)singleTapOnImageView:(UITapGestureRecognizer *)singleTap {
    if ([self.imageScrollDelegate respondsToSelector:@selector(didSingleTapImageView:index:)]) {
        [self.imageScrollDelegate didSingleTapImageView:(UIImageView *)singleTap.view index:self.imageIndex];
    }
}

- (void)doubleTapOnImageView:(UITapGestureRecognizer *)doubleTap {
    UIView *imageView = doubleTap.view;
    
    UIScrollView *imageScroll = (UIScrollView *)imageView.superview;
    if (imageScroll.zoomScale == imageScroll.maximumZoomScale) {
        imageScroll.scrollEnabled = NO;
        [imageScroll setZoomScale:imageScroll.minimumZoomScale animated:YES];
    } else {
        imageScroll.scrollEnabled = YES;
        [imageScroll setZoomScale:imageScroll.maximumZoomScale animated:YES];
    }
    
    if ([self.imageScrollDelegate respondsToSelector:@selector(didDoubleTapImageView:index:zoomUp:)]) {
        [self.imageScrollDelegate didDoubleTapImageView:(UIImageView *)doubleTap.view index:self.imageIndex zoomUp:imageScroll.scrollEnabled];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.contentScrollView]) {
        NSUInteger minIndex = ceilf(scrollView.contentOffset.x/CGRectGetWidth(self.frame));
        NSUInteger maxIndex = floorf(scrollView.contentOffset.x/CGRectGetWidth(self.frame));
        
        if (scrollView.isDragging) {
            if (scrollView.contentOffset.x > self.oldOffsetX) {
                NSUInteger imageCount = [self.imageScrollDelegate numberOfItems];
                if (self.imageIndex != maxIndex && maxIndex <= imageCount - 1) {
                    self.imageIndex = maxIndex;
                    [self changeBackgroundImageView:maxIndex];
                    
                    [self loadImageView];
                    
                    if ([self.imageScrollDelegate respondsToSelector:@selector(didChangeImageView:)]) {
                        [self.imageScrollDelegate didChangeImageView:maxIndex];
                    }
                }
            } else {
                if (self.imageIndex != minIndex) {
                    if (minIndex <= 0) {
                        minIndex = 0;
                    }
                    
                    self.imageIndex = minIndex;
                    [self changeBackgroundImageView:minIndex];
                    
                    [self loadImageView];
                    
                    if ([self.imageScrollDelegate respondsToSelector:@selector(didChangeImageView:)]) {
                        [self.imageScrollDelegate didChangeImageView:minIndex];
                    }
                }
            }
        }
        
        self.oldOffsetX = scrollView.contentOffset.x;
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.contentScrollView]) {
        CGFloat offsetX = 0;
        CGFloat offsetY = 0;
        
        UIImageView *imageView = (UIImageView *)scrollView.subviews[0];
        
        if ((CGRectGetWidth(self.frame) - CGRectGetWidth(imageView.frame)) > 0) {
            offsetX = (CGRectGetWidth(self.frame) - CGRectGetWidth(imageView.frame))/2.f;
        }
        
        if ((CGRectGetHeight(self.frame) - CGRectGetHeight(imageView.frame)) > 0) {
            offsetY = (CGRectGetHeight(self.frame) - CGRectGetHeight(imageView.frame))/2.f;
        }
        
        scrollView.contentInset = UIEdgeInsetsMake(offsetY, offsetX, 0, 0);
    }
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if (![scrollView isEqual:self.contentScrollView]) {
        return scrollView.subviews[0];
    }
    
    return nil;
}

@end
