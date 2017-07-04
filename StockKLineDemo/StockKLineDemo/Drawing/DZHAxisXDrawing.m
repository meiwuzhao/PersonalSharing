//
//  DZHAxisXDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHAxisXDrawing.h"
#import "DZHDrawingItems.h"

@implementation DZHAxisXDrawing

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    NSParameterAssert(self.drawingDataSource != nil);
    
    NSArray *datas              = [self.drawingDataSource datasForDrawing:self inRect:rect];
    if ([datas count] == 0)
        return;
    
    id<DZHAxisLineItem> entity  = [datas firstObject];
    CGFloat maxX                = CGRectGetMaxX(rect);
    CGFloat y                   = CGRectGetMaxY(rect) - self.labelSpace;
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    
    CGSize size                 = [entity.labelText sizeWithFont:self.labelFont constrainedToSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    CGFloat lastX               = CGFLOAT_MIN;
    CGColorRef textColor        = self.labelColor.CGColor;
    
    for (id<DZHAxisLineItem> entity in datas)
    {
        CGFloat x               = entity.location.x;
        NSString *labelText     = entity.labelText;
        CGRect tickRect         = CGRectMake(x - size.width * .5, y, size.width+5, size.height);
        CGFloat centerX         = CGRectGetMidX(tickRect);
        
        if (tickRect.origin.x - lastX < size.width)
            continue;
        
        if (!entity.notDrawLine && x > rect.origin.x && x < maxX) //只有在范围内的才绘制
        {
            if (entity.dashLengths)
            {
                NSInteger count = [entity.dashLengths count];
                CGFloat lenghts[count];
                for (int z = 0; z < count; z ++)
                {
                    lenghts[z]  = [[entity.dashLengths objectAtIndex:z] doubleValue];
                }
                
                CGContextSetLineDash(context, 0, lenghts, count);
            }
            else
                CGContextSetLineDash (context, 0, 0, 0);
            
            CGContextAddLines(context, (CGPoint[]){CGPointMake(x, rect.origin.y), CGPointMake(x, y)}, 2);
            CGContextStrokePath(context);
        }
        
        if (self.labelSpace > 0 && centerX > rect.origin.x && CGRectGetMaxX(tickRect) <= maxX) //只有在范围内的才绘制
        {
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, textColor);
            [self drawStrInRect:labelText
                           rect:tickRect
                           font:self.labelFont
                      alignment:NSTextAlignmentLeft];
            CGContextRestoreGState(context);
            
            lastX               = tickRect.origin.x;
        }
    }
    CGContextRestoreGState(context);
}

@end

