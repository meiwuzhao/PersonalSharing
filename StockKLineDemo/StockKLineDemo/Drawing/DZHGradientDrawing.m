//
//  DZHGradientDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHGradientDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHGradientDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource);
    
    NSArray *datas                  = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    CGContextSaveGState(context);
    CGPoint start                   = rect.origin;
    CGPoint end                     = CGPointMake(rect.origin.x, CGRectGetMaxY(rect));
    
    for (id<DZHGradientItem> model in datas)
    {
        CGPoint *pts                = model.points;
        NSInteger count             = model.count;
        if (model.isBezier)
        {
            NSInteger end           = count - 1;
            CGContextMoveToPoint(context, pts[0].x, pts[0].y);
            for (int i = 0; i < end; i++)
            {
                CGContextAddQuadCurveToPoint(context, pts[i].x, pts[i].y, (pts[i].x + pts[i+1].x) * 0.5, (pts[i].y + pts[i+1].y) * 0.5);
            }
            if (end > 0) CGContextAddLineToPoint(context, pts[end].x, pts[end].y);
        }
        else
        {
            CGContextAddLines(context, pts, count);
        }
        
        CGContextAddLineToPoint(context, pts[count - 1].x, CGRectGetMaxY(rect));
        CGContextAddLineToPoint(context, pts[0].x, CGRectGetMaxY(rect));
        
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGGradientDrawingOptions options = kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation;
        
        CGColorSpaceRef colorSpace  = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient      = CGGradientCreateWithColors(colorSpace, (CFArrayRef)model.colors, NULL);
        CGColorSpaceRelease(colorSpace);
        
        CGContextDrawLinearGradient(context, gradient, start, end, options);
        
        CGGradientRelease(gradient);
    }
    
    CGContextRestoreGState(context);
}

@end
