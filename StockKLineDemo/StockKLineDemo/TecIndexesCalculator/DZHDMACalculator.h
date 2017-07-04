//
//  DZHDMACalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCalculatorBase.h"

@interface DZHDMACalculator : DZHCalculatorBase

@property (nonatomic) int shortDay;

@property (nonatomic) int longDay;

- (instancetype)initWithDMAShortDay:(int)shortDay longDay:(int)longDay;

@end

