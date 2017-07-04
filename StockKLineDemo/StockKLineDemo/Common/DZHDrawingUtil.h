//
//  DZHDrawingUtil.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZHDrawingUtil : NSObject

/**
 * 计算值的y坐标
 */
+ (CGFloat)locationYForValue:(float)v withMax:(float)max min:(float)min top:(CGFloat)top bottom:(CGFloat)bottom;


@end
