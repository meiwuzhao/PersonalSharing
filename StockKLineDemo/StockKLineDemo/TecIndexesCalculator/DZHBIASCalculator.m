//
//  DZHBIASCalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHBIASCalculator.h"

@interface BIASItemCalculator : NSObject
{
    float                   *_closes;// N日内收盘价集合
    float                   _sumClose;
}

@property (nonatomic)int BIASDay;

-(instancetype)initWithBIASDay:(int)day;

@end

@implementation BIASItemCalculator

-(instancetype)initWithBIASDay:(int)day
{
    if (self = [super init])
    {
        self.BIASDay            = day;
        _closes                 = malloc(sizeof(float) * day);
    }
    return self;
}

- (void)dealloc
{
    free(_closes);
//    [super dealloc];
}

- (void)reset
{
    memset(_closes, 0, sizeof(float) * _BIASDay);
}

//BIAS=(收盘价-收盘价的N日简单平均)/收盘价的N日简单平均*100
- (float)technicalIndexesWithModel:(id<DZHBIASModel>)model atIndex:(NSInteger)index
{
    float close                 = model.close;
    _sumClose                   += close;
    float ma;
    if (index >= _BIASDay)
    {
        int idx                 = index % _BIASDay;
        _sumClose               -= _closes[idx];
        _closes[idx]            = close;
        
        ma                      = _sumClose / _BIASDay;
    }
    else
    {
        _closes[index]          = close;
        ma                      = _sumClose / (index + 1);
    }
    
    return 100. * (close - ma) / ma;
}

@end

@implementation DZHBIASCalculator
{
    BIASItemCalculator      *_cal1;
    BIASItemCalculator      *_cal2;
    BIASItemCalculator      *_cal3;
}

-(instancetype)initWithBIASDay1:(int)day1 BIASDay2:(int)day2 BIASDay3:(int)day3
{
    if (self = [super init])
    {
        _cal1               = [[BIASItemCalculator alloc] initWithBIASDay:day1];
        _cal2               = [[BIASItemCalculator alloc] initWithBIASDay:day2];
        _cal3               = [[BIASItemCalculator alloc] initWithBIASDay:day3];
    }
    return self;
}


- (void)travelerBeginAtIndex:(NSInteger)index
{
    [_cal1 reset];
    [_cal2 reset];
    [_cal3 reset];
}

//BIAS=(收盘价-收盘价的N日简单平均)/收盘价的N日简单平均*100
- (void)travelerWithLastData:(id<DZHBIASModel>)last currentData:(id<DZHBIASModel>)currentData index:(NSInteger)index
{
    currentData.BIAS1       = [_cal1 technicalIndexesWithModel:currentData atIndex:index];
    currentData.BIAS2       = [_cal2 technicalIndexesWithModel:currentData atIndex:index];
    currentData.BIAS3       = [_cal3 technicalIndexesWithModel:currentData atIndex:index];
}

@end
