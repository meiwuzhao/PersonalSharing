//
//  DZHKLineContainer.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineContainer.h"
#import "UIColor+RGB.h"
#import "DZHKLineDrawing.h"
#import "DZHAxisYDrawing.h"
#import "DZHKLineEntity.h"

@interface DZHKLineContainer ()<UIGestureRecognizerDelegate>

@end

@implementation DZHKLineContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.decelerationRate           = .2;
        self.showsHorizontalScrollIndicator = NO;
        
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scaleKLine:)];
        pinch.delegate                  = self;
        [self addGestureRecognizer:pinch];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressKLine:)];
        [self addGestureRecognizer:longPress];
        
        [pinch requireGestureRecognizerToFail:longPress];
        [self.panGestureRecognizer requireGestureRecognizerToFail:longPress];
        [self.pinchGestureRecognizer requireGestureRecognizerToFail:longPress];
    }
    return self;
}

- (void)scaleKLine:(UIPinchGestureRecognizer *)gesture
{
    if (_kLineDelegate && [_kLineDelegate respondsToSelector:@selector(kLineContainer:scaled:)])
    {
        [_kLineDelegate kLineContainer:self scaled:gesture.scale];
    }
}

- (void)longPressKLine:(UILongPressGestureRecognizer *)gesture
{
    if (_kLineDelegate && [_kLineDelegate respondsToSelector:@selector(kLineContainer:longPressLocation:state:)])
    {
        CGPoint point       = [gesture locationInView:self];
        [_kLineDelegate kLineContainer:self longPressLocation:point state:gesture.state];
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]])
    {
        if (_kLineDelegate && [_kLineDelegate respondsToSelector:@selector(scaledOfkLineContainer:)])
        {
            ((UIPinchGestureRecognizer *)gestureRecognizer).scale   = [_kLineDelegate scaledOfkLineContainer:self];
        }
    }
    return YES;
}

@end

