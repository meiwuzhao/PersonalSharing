//
//  DZHRSICalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//
/*
 RSI1，白线，一般是6日相对强弱指标
 RSI2，黄线， 一般是12日相对强弱指标
 RSI3，紫线，一般是24日相对强弱指标
 */

#import "DZHCalculatorBase.h"

@interface DZHRSICalculator : DZHCalculatorBase<DZHDataTraveler>

- (instancetype)initWithRSI1:(int)rsiDay1 RSI2:(int)rsiDay2 RSI3:(int)rsiDay3;

@property (nonatomic) int RSIDay1;

@property (nonatomic) int RSIDay2;

@property (nonatomic) int RSIDay3;

@end
