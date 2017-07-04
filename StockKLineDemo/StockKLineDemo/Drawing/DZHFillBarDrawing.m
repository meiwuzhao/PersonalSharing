//
//  DZHFillBarDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHFillBarDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHFillBarDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    for (id<DZHBarItem> entity in datas)
    {
        CGContextSetFillColorWithColor(context, entity.barFillColor.CGColor);
        CGContextFillRect(context, entity.barRect);
    }
    CGContextRestoreGState(context);
}

@end
