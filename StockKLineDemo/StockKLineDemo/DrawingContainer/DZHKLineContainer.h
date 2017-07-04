//
//  DZHKLineContainer.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHScrollContainer.h"

@protocol DZHKLineContainerDelegate;

@interface DZHKLineContainer : DZHScrollContainer

@property (nonatomic, assign) id<DZHKLineContainerDelegate> kLineDelegate;

@end

@protocol DZHKLineContainerDelegate <NSObject>

- (CGFloat)scaledOfkLineContainer:(DZHKLineContainer *)container;

- (void)kLineContainer:(DZHKLineContainer *)container scaled:(CGFloat)scale;

- (void)kLineContainer:(DZHKLineContainer *)container longPressLocation:(CGPoint)point state:(UIGestureRecognizerState)state;

@end
