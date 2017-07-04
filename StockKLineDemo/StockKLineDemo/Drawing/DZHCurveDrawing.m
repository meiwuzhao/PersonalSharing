//
//  DZHCurveDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCurveDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHCurveDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    
    for (id<DZHLineItem> model in datas)
    {
        CGPoint *pts                = model.points;
        
        CGContextSetStrokeColorWithColor(context, model.color.CGColor);
        
        if (model.isBezier)     //平滑曲线，如移动平均线
        {
            NSInteger end           = model.count - 1;
            CGContextMoveToPoint(context, pts[0].x, pts[0].y);
            for (int i = 0; i < end; i++)
            {
                CGContextAddQuadCurveToPoint(context, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
            }
            if (end > 0) CGContextAddLineToPoint(context, pts[end].x, pts[end].y);
        }
        else        //非平滑曲线，如KDJ等指标
        {
            CGContextAddLines(context, pts, model.count);
        }
        
        CGContextStrokePath(context);
    }
    CGContextRestoreGState(context);
}

@end
