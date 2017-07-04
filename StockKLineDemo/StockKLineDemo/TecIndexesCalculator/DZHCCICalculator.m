//
//  DZHCCICalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCCICalculator.h"

@implementation DZHCCICalculator
{
    float                   *_closes;
    float                   *_highs;
    float                   *_lows;
    
    float                   TYPTotal;
}

-(instancetype)initWithCCIDay:(int)cciDay
{
    if (self = [super init])
    {
        self.CCIDay             = cciDay;
        self.coefficient        = 0.015;
        _closes                 = malloc(sizeof(float) * cciDay);
        _highs                  = malloc(sizeof(float) * cciDay);
        _lows                   = malloc(sizeof(float) * cciDay);
    }
    return self;
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    memset(_closes, 0, sizeof(float) * _CCIDay);
    memset(_highs, 0, sizeof(float) * _CCIDay);
    memset(_lows, 0, sizeof(float) * _CCIDay);
}

//TYP:=(HIGH+LOW+CLOSE)/3;
//CCI:(TYP-MA(TYP,N))/(0.015*AVEDEV(TYP,N));
//TYP =（最高价+最低价+收盘价）÷3
//MA(TYP,N) 是N天的TYP的平均值
//AVEDEV(TYP,N) 是对TYP进行绝对平均偏差的计算。
//也就是说N天的TYP减去MA(TYP,N)的绝对值的和的平均值。
//表达式：
//MA = MA(TYP,N)
//AVEDEV(TYP,N) =( | 第N天的TYP - MA |   +  | 第N-1天的TYP - MA | + ...... + | 第1天的TYP - MA | ) ÷ N
//CCI = （TYP－MA）÷ AVEDEV(TYP,N)÷0.015
- (void)travelerWithLastData:(id<DZHCCIModel>)last currentData:(id<DZHCCIModel>)currentData index:(NSInteger)index
{
    int idx                 = index % _CCIDay;
    float MA;
    float MD                = .0;
    float TYP               = (currentData.close + currentData.high + currentData.low) / 3.;
    TYPTotal                += TYP;
    if (index >= _CCIDay)
    {
        float subTYP        = (_closes[idx] + _highs[idx] + _lows[idx]) / 3.;
        TYPTotal            -= subTYP;
        
        //减去旧值后，使用新的值替代
        _closes[idx]        = currentData.close;
        _highs[idx]         = currentData.high;
        _lows[idx]          = currentData.low;
        
        MA                  = TYPTotal / _CCIDay;
    }
    else
    {
        _closes[idx]        = currentData.close;
        _highs[idx]         = currentData.high;
        _lows[idx]          = currentData.low;
        MA                  = TYPTotal / (index + 1);
    }
    
    if (index >= _CCIDay - 1)
    {
        for (int i = 0; i < _CCIDay; i++)
        {
            float subTYP    = (_closes[i] + _highs[i] + _lows[i]) / 3.;
            MD              += ABS(subTYP - MA);
        }
        
        MD                  = MD / _CCIDay;
        
        currentData.CCI     = (TYP - MA) / (MD * _coefficient);
    }
    
    //    printf("(%d,%d,%d) TYP:%.2f Total:%.2f  MA:%.2f  MD:%.2f  CCI:%.2f \n",currentData.high,currentData.low,currentData.close,TYP,TYPTotal,MA,MD,currentData.CCI);
}

@end
