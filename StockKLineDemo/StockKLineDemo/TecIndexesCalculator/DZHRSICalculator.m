//
//  DZHRSICalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHRSICalculator.h"

#define kDefault

@implementation DZHRSICalculator
{
    // N天的涨跌点数和，需要使用N＋1天的数据才能计算出来
    float                 *RSI1Closes; //RSIDay1 + 1天收盘价集合
    float                 *RSI2Closes; //RSIDay2 + 1天收盘价集合
    float                 *RSI3Closes; //RSIDay3 + 1天收盘价集合
}

- (instancetype)initWithRSI1:(int)rsiDay1 RSI2:(int)rsiDay2 RSI3:(int)rsiDay3
{
    if (self = [super init])
    {
        self.RSIDay1            = rsiDay1;
        self.RSIDay2            = rsiDay2;
        self.RSIDay3            = rsiDay3;
        
        RSI1Closes              = malloc(sizeof(float) * (rsiDay1 + 1));
        RSI2Closes              = malloc(sizeof(float) * (rsiDay2 + 1));
        RSI3Closes              = malloc(sizeof(float) * (rsiDay3 + 1));
    }
    return self;
}

- (void)dealloc
{
    free(RSI1Closes);
    free(RSI2Closes);
    free(RSI3Closes);
    
//    [super dealloc];
}
- (void)travelerBeginAtIndex:(NSInteger)index
{
    memset(RSI1Closes, 0, sizeof(float) * (_RSIDay1 + 1));
    memset(RSI2Closes, 0, sizeof(float) * (_RSIDay2 + 1));
    memset(RSI3Closes, 0, sizeof(float) * (_RSIDay3 + 1));
}

//RSI=100×RS/(1+RS)
//RS=X天的平均上涨点数/X天的平均下跌点数
//综合RSI与RS的公式，可得RSI = 100 * X天的总上涨点数 / (X天的总上涨点数 + X天的总下跌点数)
- (void)travelerWithLastData:(id<DZHRSIModel>)last currentData:(id<DZHRSIModel>)currentData index:(NSInteger)index
{
    if (index >= _RSIDay1)
    {
        currentData.RSI1    = [self calculateRSIWithCloses:RSI1Closes cyle:_RSIDay1 close:currentData.close index:index];
    }
    else
    {
        RSI1Closes[index]  = currentData.close;
    }
    
    if (index >= _RSIDay2)
    {
        currentData.RSI2    = [self calculateRSIWithCloses:RSI2Closes cyle:_RSIDay2 close:currentData.close index:index];
    }
    else
    {
        RSI2Closes[index]  = currentData.close;
    }
    
    if (index >= _RSIDay3)
    {
        currentData.RSI3    = [self calculateRSIWithCloses:RSI3Closes cyle:_RSIDay3 close:currentData.close index:index];
    }
    else
    {
        RSI3Closes[index]  = currentData.close;
    }
}

/**
 * 计算RSI值
 *
 */
- (float)calculateRSIWithCloses:(float *)closes cyle:(int)cycle
{
    float du                = .0; //总上涨点数
    float dd                = .0; //总下跌点数
    for (int i = 1; i <= cycle; i ++)
    {
        float lastClose     = closes[i - 1];
        float close         = closes[i];
        
        if (close > lastClose)
            du              += close - lastClose;
        else
            dd              += lastClose - close;
    }
    return du + dd == 0 ? 0 : 100. * du / (du + dd);
}

/**
 * 计算RSI值，并将最新的收盘价push进栈，如果数据个数大于缓存大小，则将最后一个收盘价出栈
 *
 */
- (float)calculateRSIWithCloses:(float *)closes cyle:(int)cycle close:(float)close index:(NSInteger)index
{
    BOOL needPop                    = index > cycle; //是否需要出栈
    if (!needPop) //不需要出栈，直接push进来
        closes[index]               = close;
    
    float du                        = 0; //总上涨点数
    float dd                        = 0; //总下跌点数
    int begin                       = needPop ? 2 : 1; //如果出栈，则要移动栈数据，所以从2开始
    int end                         = needPop ? cycle + 1 : cycle; //如果出栈，起始从2开始，保证循环次数，则较非出栈情况＋1
    float lastClose,curClose;
    for (int i = begin; i <= end; i ++)
    {
        lastClose                   = closes[i - 1];
        curClose                    = i == cycle + 1 ? close : closes[i];
        
        if (curClose > lastClose)
            du                      += curClose - lastClose;
        else
            dd                      += lastClose - curClose;
        
        if (needPop)
        {
            if (i == 2)
                closes[i - 2]       = lastClose;
            
            closes[i - 1]           = curClose;
        }
    }
    return du + dd == 0 ? 0 : 100. * du / (du + dd);
}

@end
