//
//  DZHRectangleDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHRectangleDrawing.h"

@implementation DZHRectangleDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    CGContextSaveGState(context);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, 1.);
    CGContextStrokeRect(context, rect);
    CGContextRestoreGState(context);
}

@end
