//
//  DZHDataProviderBase.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDataProviderBase.h"

@implementation DZHDataProviderBase

@synthesize context         = _context;
@synthesize colorProvider   = _colorProvider;

#pragma mark - DZHDataProviderProtocol

- (int)cycleForType:(NSInteger)type
{
    return 0;
}

- (NSInteger)beginOfIndex:(NSInteger)idx indexCycle:(int)cycle
{
    return idx < cycle ? cycle : idx;
}

- (void)setupPropertyWhenTravelLastData:(id)lastData currentData:(id)curData index:(NSInteger)index
{
    
}

- (void)setupMaxAndMinWhenTravelLastData:(id)lastData currentData:(id)data index:(NSInteger)index
{
    
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}

- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}


@end

