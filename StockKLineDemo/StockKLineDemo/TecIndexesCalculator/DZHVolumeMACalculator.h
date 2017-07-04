//
//  DZHVolumeMACalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCalculatorBase.h"

@interface DZHVolumeMACalculator : DZHCalculatorBase<DZHDataTraveler>

@property (nonatomic) int cycle;

- (instancetype)initWithMACycle:(int)cycle;

@end

