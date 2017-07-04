//
//  DZHDrawingUtil.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawingUtil.h"

@implementation DZHDrawingUtil

+ (CGFloat)locationYForValue:(float)v withMax:(float)max min:(float)min top:(CGFloat)top bottom:(CGFloat)bottom
{
    CGFloat y;
    
    if (max == min)
        y = bottom;
    else if (v <= max && v >= min)
        y = round(bottom - (v - min)/(max - min)*(bottom - top));
    else
        y = (v < min) ? bottom : top;
    
    return y;
}

@end
