//
//  DZHKLineDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHKLineDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    for (id<DZHKLineItem> entity in datas)
    {
        CGContextSetFillColorWithColor(context, entity.stickColor.CGColor);
        CGContextAddRect(context, entity.solidRect);
        CGContextAddRect(context, entity.stickRect);
        CGContextFillPath(context);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end



