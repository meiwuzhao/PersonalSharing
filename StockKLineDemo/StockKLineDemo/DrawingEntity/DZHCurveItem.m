//
//  DZHCurveItem.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCurveItem.h"

@implementation DZHCurveItem

@synthesize color           = _color;
@synthesize count           = _count;
@synthesize isBezier        = _isBezier;
@synthesize points          = _points;
@synthesize colors          = _colors;

- (void)dealloc
{
    if (_points != NULL)
        free(_points);
}

- (void)setPoints:(CGPoint *)points withCount:(NSInteger)count
{
    if (_points != NULL)
        free(_points);
    
    size_t size         = sizeof(CGPoint) * count;
    _points             = malloc(size);
    memcpy(_points, points, size);
    _count              = count;
}

@end
