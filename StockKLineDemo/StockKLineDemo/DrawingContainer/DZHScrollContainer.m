//
//  DZHScrollContainer.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHScrollContainer.h"

@implementation DZHScrollContainer

@synthesize drawingFrame        = _virtualFrame;
@synthesize drawingTag          = _drawingTag;
@synthesize drawingDelegate     = _drawingDelegate;
@synthesize drawingDataSource   = _drawingDataSource;

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _container              = [[DZHContainer alloc] init];
        _container.drawingFrame = CGRectMake(.0, .0, frame.size.width, frame.size.height);
    }
    return self;
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef context        = UIGraphicsGetCurrentContext();
    
    [self drawRect:rect withContext:context];
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
//    if (self.drawingDelegate && [self.drawingDelegate respondsToSelector:@selector(prepareDrawing:inRect:)])
//    {
//        [self.drawingDelegate prepareDrawing:self inRect:rect];
//    }
    
    [_container drawRect:rect withContext:context];
//    
//    if (self.drawingDelegate && [self.drawingDelegate respondsToSelector:@selector(completeDrawing:inRect:)])
//    {
//        [self.drawingDelegate completeDrawing:self inRect:rect];
//    }
}

#pragma mark - DZHDrawingContainer

- (NSArray *)subDrawings
{
    return [_container subDrawings];
}

- (void)setVirtualFrame:(CGRect)drawingFrame
{
    _container.drawingFrame     = drawingFrame;
}

- (CGRect)drawingFrame
{
    return _container.drawingFrame;
}

- (void)addDrawing:(id<DZHDrawing>)drawing
{
    [_container addDrawing:drawing];
}

- (void)removeDrawing:(id<DZHDrawing>)drawing
{
    [_container removeDrawing:drawing];
}

- (void)insertDrawing:(id<DZHDrawing>)drawing atIndex:(NSInteger)index
{
    [_container insertDrawing:drawing atIndex:index];
}

- (CGRect)realRectForVirtualRect:(CGRect)virtualRect
{
    return [_container realRectForVirtualRect:virtualRect];
}

@end

