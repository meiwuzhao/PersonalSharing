//
//  DZHMACalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHMACalculator.h"

@implementation DZHMACalculator
{
    float                   _total;
    float                   *_closes;//N天收盘数据集合
}

- (instancetype)initWithMADay:(int)MADay
{
    if (self  = [super init])
    {
        self.MADay          = MADay;
        _closes             = malloc(sizeof(float) * MADay);
    }
    return self;
}

- (void)dealloc
{
    free(_closes);
//    [super dealloc];
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    [self reset];
}

- (void)travelerWithLastData:(id<DZHKLineModel>)last currentData:(id<DZHKLineModel>)currentData index:(NSInteger)index
{
    [currentData setMA:[self technicalIndexesTravelWithModel:currentData atIndex:index] withCycle:_MADay];
}

- (void)reset
{
    _total                  = 0;
    memset(_closes, 0, sizeof(float) * _MADay);
}

- (float)technicalIndexesTravelWithModel:(id<DZHDrawingModel>)model atIndex:(NSInteger)index
{
    float close                 = model.close;
    int cycle                   = _MADay;
    float ma                    = .0;
    _total                      += close;
    if (index >= cycle)
    {
        int idx                 = index % cycle;//缓存中需要重新设置值的索引，当前索引-周期所在数据的值在缓存中的索引
        _total                  -= _closes[idx];
        ma                      = _total / cycle;
        _closes[idx]            = close;
    }
    else if (index == cycle - 1) //均线第一个点
    {
        ma                      = _total / cycle;
        _closes[index]          = close;
    }
    else
    {
        _closes[index]          = close;
    }
    return ma;
}

@end
