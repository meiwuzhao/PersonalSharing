//
//  DZHCCICalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCalculatorBase.h"

@interface DZHCCICalculator : DZHCalculatorBase

- (instancetype)initWithCCIDay:(int)cciDay;

@property (nonatomic) int CCIDay;

@property (nonatomic) float coefficient;//系数

@end
