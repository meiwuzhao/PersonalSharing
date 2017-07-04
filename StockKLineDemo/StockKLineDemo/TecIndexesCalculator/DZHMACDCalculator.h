//
//  DZHMACDCalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//
/*
 黄线：MACD
 白线：DIF
 */
#import "DZHCalculatorBase.h"

@interface DZHMACDCalculator : DZHCalculatorBase<DZHDataTraveler>

- (instancetype)initWithEMAFastDay:(int)fast slowDay:(int)slow difDay:(int)difDay;

@property (nonatomic) int fastDay;/**快速移动平均值周期*/

@property (nonatomic) int slowDay;/**慢速移动平均值周期*/

@property (nonatomic) int difDay;

@end
