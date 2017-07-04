//
//  DZHWRCalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHWRCalculator.h"

@implementation DZHWRCalculator
{
    float                     *_WR1Lows;//wr1天内最低价
    float                     *_WR1Highs;//wr1天内高价
    float                     *_WR2Lows;//wr2天内最低价
    float                     *_WR2Highs;//wr2天内高价
}

-(instancetype)initWithWRDay1:(int)wr1 WRDay2:(int)wr2
{
    if (self = [super init])
    {
        self.WRDay1             = wr1;
        self.WRDay2             = wr2;
        
        _WR1Lows                = malloc(sizeof(float) * wr1);
        _WR1Highs               = malloc(sizeof(float) * wr1);
        
        _WR2Lows                = malloc(sizeof(float) * wr2);
        _WR2Highs               = malloc(sizeof(float) * wr2);
    }
    return self;
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    memset(_WR1Lows, 0, sizeof(float) * _WRDay1);
    memset(_WR1Highs, 0, sizeof(float) * _WRDay1);
    
    memset(_WR2Lows, 0, sizeof(float) * _WRDay2);
    memset(_WR2Highs, 0, sizeof(float) * _WRDay2);
}

//计算N日内的最高价和N日内的最低价
- (void)calculateMax:(float *)max min:(float *)min fromHighs:(float *)highs lows:(float *)lows cycle:(int)cycle
{
    float higher      = highs[0];
    float lower       = lows[0];
    
    for (int i = 1; i < cycle; i++)
    {
        if (higher < highs[i])
            higher  = highs[i];
        
        if (lower > lows[i])
            lower   = lows[i];
    }
    
    *max            = higher;
    *min            = lower;
}

//WR(N) = 100 * [ HIGH(N)-C ] / [ HIGH(N)-LOW(N) ]
- (void)travelerWithLastData:(id<DZHWRModel>)last currentData:(id<DZHWRModel>)currentData index:(NSInteger)index
{
    int idx                 = index % _WRDay1;
    _WR1Highs[idx]          = currentData.high;
    _WR1Lows[idx]           = currentData.low;
    
    if (index >= _WRDay1)
    {
        float high1,low1;
        [self calculateMax:&high1 min:&low1 fromHighs:_WR1Highs lows:_WR1Lows cycle:_WRDay1];
        currentData.WR1     = 100. * (high1 - currentData.close) / (high1 - low1);
    }
    
    idx                     = index % _WRDay2;
    _WR2Highs[idx]          = currentData.high;
    _WR2Lows[idx]           = currentData.low;
    
    if (index >= _WRDay2)
    {
        float high2,low2;
        [self calculateMax:&high2 min:&low2 fromHighs:_WR2Highs lows:_WR2Lows cycle:_WRDay2];
        currentData.WR2     = 100. * (high2 - currentData.close) / (high2 - low2);
    }
    
    printf("WR1:%.2f  WR2:%.2f \n",currentData.WR1, currentData.WR2);
}

@end
