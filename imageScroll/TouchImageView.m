//
//  TouchImageView.m
//  imageScroll
//
//  Created by apple on 15/8/27.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "TouchImageView.h"

@implementation TouchImageView

- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    
    if (self) {
        self.userInteractionEnabled = YES;
        
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        self.layer.borderWidth = 2.f;
        
        //双击
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        
        //缩放
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self addGestureRecognizer:pinch];
        
        //旋转
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self addGestureRecognizer:rotation];
        
        //拖动
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleGestureRecognizer:)];
        [self addGestureRecognizer:pan];
    }
    
    return self;
}

#pragma mark - GestureRecognizer

- (void)handleGestureRecognizer:(UIGestureRecognizer *)recognizer {
    if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer *tap = (UITapGestureRecognizer *)recognizer;
        if (tap.numberOfTapsRequired == 2) {
            NSLog(@"双击");
        }
    }
    
    if ([recognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        UIPinchGestureRecognizer *pinch = (UIPinchGestureRecognizer *)recognizer;
        pinch.view.transform = CGAffineTransformScale(pinch.view.transform, pinch.scale, pinch.scale);
        
        pinch.scale = 1;
    }
    
    if ([recognizer isKindOfClass:[UIRotationGestureRecognizer class]]) {
        UIRotationGestureRecognizer *rotation = (UIRotationGestureRecognizer *)recognizer;
        rotation.view.transform = CGAffineTransformRotate(rotation.view.transform, rotation.rotation);
        
        rotation.rotation = 0;
    }
    
    if ([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)recognizer;
        CGPoint translation = [pan translationInView:self];
        pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
        
        [pan setTranslation:CGPointZero inView:self];
    }
}

@end
