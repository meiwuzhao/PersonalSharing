//
//  DZHContainer.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHContainer.h"

@implementation DZHContainer

@synthesize currentVisibleRect     = _currentVisibleRect;
@synthesize subDrawings     = _drawings;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _drawings               = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    self.currentVisibleRect                = rect;
    
    for (id<DZHDrawing> drawing in _drawings)
    {
        if (CGRectIsEmpty(drawing.drawingFrame))
            continue;
        
        CGRect realRect;
        
        if (drawing.isFixed)
        {
//            CGRect fitRect          = CGRectIntersection(rect, drawing.drawingFrame); //交集部分
//            if (CGRectIsEmpty(fitRect))
//                continue;
            
            realRect                = drawing.drawingFrame;
        }
        else
        {
            realRect                = [self realRectForVirtualRect:drawing.drawingFrame];
        }
        
        if (drawing.drawingDelegate && [drawing.drawingDelegate respondsToSelector:@selector(prepareDrawing:inRect:)])
        {
            [drawing.drawingDelegate prepareDrawing:drawing inRect:realRect];
        }
        
        [drawing drawRect:realRect withContext:context];
        
        if (drawing.drawingDelegate && [drawing.drawingDelegate respondsToSelector:@selector(completeDrawing:inRect:)])
        {
            [drawing.drawingDelegate completeDrawing:drawing inRect:realRect];
        }
    }
}

#pragma mark - DZHDrawingContainer

- (void)addDrawing:(id<DZHDrawing>)drawing
{
    drawing.container       = self;
    [_drawings addObject:drawing];
}

- (void)removeDrawing:(id<DZHDrawing>)drawing
{
    [_drawings removeObject:drawing];
}

- (void)insertDrawing:(id<DZHDrawing>)drawing atIndex:(NSInteger)index
{
    drawing.container       = self;
    [_drawings insertObject:drawing atIndex:index];
}

- (CGRect)realRectForVirtualRect:(CGRect)virtualRect
{
    return CGRectMake(_currentVisibleRect.origin.x + virtualRect.origin.x, _currentVisibleRect.origin.y + virtualRect.origin.y, virtualRect.size.width, virtualRect.size.height);
}

@end
