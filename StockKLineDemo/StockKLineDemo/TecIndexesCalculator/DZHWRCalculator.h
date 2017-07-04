//
//  DZHWRCalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
// WR威廉指标应用法则

#import "DZHCalculatorBase.h"

@interface DZHWRCalculator : DZHCalculatorBase<DZHDataTraveler>

-(instancetype)initWithWRDay1:(int)wr1 WRDay2:(int)wr2;

@property (nonatomic) int WRDay1;

@property (nonatomic) int WRDay2;

@end
