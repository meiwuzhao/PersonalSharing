//
//  DZHDataProviderContext.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDataProviderContext.h"

@implementation DZHDataProviderContext

@synthesize fromIndex;
@synthesize toIndex;

@synthesize originItemWidth;
@synthesize itemWidth;
@synthesize itemPadding;
@synthesize startLocation;

@synthesize datas;
@synthesize itemCount;

@synthesize scale;
@synthesize maxScale;
@synthesize minScale;

- (id)init
{
    self = [super init];
    if (self)
    {
        self.maxScale                   = 5.;
        self.minScale                   = .5;
        self.scale                      = 1.;
        self.originItemWidth            = 3.;
        self.itemWidth                  = 3.;
        self.itemPadding                = 1.;
    }
    return self;
}

- (void)setScale:(CGFloat)_scale
{
    if (scale != _scale)
    {
        scale               = _scale;
        
        int width           = roundf(originItemWidth * _scale);
        itemWidth           = width % 2 == 0 ? width + 1 : width;
    }
}

- (CGFloat)totalWidth
{
    return itemCount * (itemWidth + itemPadding) + itemPadding;
}

- (CGFloat)locationForIndex:(NSUInteger)index
{
    return startLocation + itemPadding + index * (itemPadding + itemWidth);
}

- (CGFloat)centerLocationForIndex:(NSUInteger)index
{
    return startLocation + itemPadding * (index + 1) + itemWidth * (index + .5);
}

- (NSUInteger)nearIndexForLocation:(CGFloat)position
{
    CGFloat index   = (position - itemPadding - startLocation) / (itemPadding + itemWidth);
    return MAX(fromIndex, MIN(index, toIndex));
}

- (void)calculateFromAndToIndexWithRect:(CGRect)rect
{
    CGFloat space               = itemWidth + itemPadding;
    fromIndex                   = MAX(ceilf((rect.origin.x - itemPadding - startLocation)/space), 0);
    toIndex                     = MIN((CGRectGetMaxX(rect) - itemPadding - startLocation)/space - 1, itemCount - 1);
}

@end
