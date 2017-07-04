//
//  DZHDrawingBase.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawingBase.h"

@implementation DZHDrawingBase

@synthesize container           = _container;
@synthesize isFixed             = _isFixed;
@synthesize drawingFrame        = _virtualFrame;
@synthesize drawingTag          = _drawingTag;
@synthesize drawingDelegate     = _drawingDelegate;
@synthesize drawingDataSource   = _drawingDataSource;

- (void)dealloc
{
    _drawingDelegate        = nil;
    _drawingDataSource      = nil;
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    
}

@end
