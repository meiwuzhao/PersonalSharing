//
//  DZHMACDCalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHMACDCalculator.h"

@implementation DZHMACDCalculator
{
    float                 EMAFast;
    float                 EMASlow;
    float                 DEA;
}

- (instancetype)initWithEMAFastDay:(int)fast slowDay:(int)slow difDay:(int)difDay
{
    if (self = [super init])
    {
        NSParameterAssert(slow > fast);
        self.fastDay    = fast;
        self.slowDay    = slow;
        self.difDay     = difDay;
    }
    return self;
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    EMAFast             = 0.;
    EMASlow             = 0.;
    DEA                 = 0.;
}

//12日EMA的计算：EMA12 = 前一日EMA12 X 11/13 + 今日收盘 X 2/13
//26日EMA的计算：EMA26 = 前一日EMA26 X 25/27 + 今日收盘 X 2/27
//差离值（DIF）的计算： DIF = EMA12 - EMA26 。
//今日DEA = （前一日DEA X 8/10 + 今日DIF X 2/10）
- (void)travelerWithLastData:(id<DZHMACDModel>)last currentData:(id<DZHMACDModel>)currentData index:(NSInteger)index
{
    float close         = currentData.close;
    float DIF           = 0.;
    
    if (index == 0)
    {
        EMAFast         = close;
        EMASlow         = close;
    }
    else
    {
        EMAFast         = EMAFast * (_fastDay - 1) / (_fastDay + 1) + close * 2 / (_fastDay + 1);
        EMASlow         = EMASlow * (_slowDay - 1) / (_slowDay + 1) + close * 2 / (_slowDay + 1);
        DIF             = EMAFast - EMASlow;
        DEA             = DEA * (_difDay - 1) / (_difDay + 1) + DIF * 2 / (_difDay + 1);
    }
    
    currentData.DIF     = DIF;
    currentData.DEA     = DEA;
    currentData.MACD    = 2 * (DIF - DEA);
}

@end
