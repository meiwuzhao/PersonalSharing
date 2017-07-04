//
//  DZHKDJCalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCalculatorBase.h"

@interface DZHKDJCalculator : DZHCalculatorBase<DZHDataTraveler>

- (instancetype)initWithKDay:(int)kDay DDay:(int)dDay rsvDay:(int)rsvDay;

@property (nonatomic) int kDay;

@property (nonatomic) int dDay;

@property (nonatomic) int rsvDay;

@end
