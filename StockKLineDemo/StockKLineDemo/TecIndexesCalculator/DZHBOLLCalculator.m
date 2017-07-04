//
//  DZHBOLLCalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHBOLLCalculator.h"

@implementation DZHBOLLCalculator
{
    float                       _total;
    float                       *_closes;//N天收盘数据集合
}

- (instancetype)initWithBOLLDay:(int)BOLLDay;
{
    if (self = [super init])
    {
        self.BOLLDay            = BOLLDay;
        
        _closes                 = malloc(sizeof(float) * BOLLDay);
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
    memset(_closes, 0, sizeof(float) * _BOLLDay);
}

/**
 *
 *   （1）计算MA
 *   MA=N日内的收盘价之和÷N
 *   （2）计算标准差MD
 *   MD=平方根N日的（C－MA）的两次方之和除以N
 *   （3）计算MB、UP、DN线
 *   MB=（N－1）日的MA
 *   UP=MB＋2×MD
 *   DN=MB－2×MD
 *
 *  计算结果不需要调整小数位数，因为BOLL线需要绘制美国线，使用的是没有调整过的价格数据
 */
- (void)travelerWithLastData:(id<DZHBOLLModel>)last currentData:(id<DZHBOLLModel>)currentData index:(NSInteger)index
{
    int idx                     = index % _BOLLDay;
    float close                 = currentData.close;
    float MID                   = .0;
    _total                      += close;
    if (index >= _BOLLDay)
    {
        _total                  -= _closes[idx];
        _closes[idx]            = close;
        
        MID                     = _total / _BOLLDay;
        
        float sum               = [self sumForCloseSubMA:_closes cycle:_BOLLDay MA:MID];
        float MD                = sqrtf(ABS(sum) / _BOLLDay);
        
        if (sum < 0)
            MD                  = -MD;
        MD                      *= 2;
        currentData.UPP         = MID + MD;
        currentData.MID         = MID;
        currentData.LOW         = MID - MD;
    }
    else
    {
        _closes[idx]            = close;
    }
    
    //    printf("UPP:%.2f  MID:%.2f  LOW:%.2f \n",currentData.UPP/100,currentData.MID/100,currentData.LOW/100);
}

// N日的（C－MA）的两次方之和
- (float)sumForCloseSubMA:(float *)closes cycle:(int)cycle MA:(float)MA
{
    float sum                   = .0;
    for (int i = 0; i < cycle; i ++)
    {
        sum                     += (closes[i] - MA) * (closes[i] - MA);
    }
    return sum;
}

@end
