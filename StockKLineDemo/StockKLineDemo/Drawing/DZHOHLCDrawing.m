//
//  DZHOHLCDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHOHLCDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHOHLCDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    for (id<DZHOHLCItem> entity in datas)
    {
        CGContextSetStrokeColorWithColor(context, entity.lineColor.CGColor);
        CGContextAddLines(context, entity.linePoints, kOHLCPointCount);
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end
