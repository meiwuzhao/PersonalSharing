//
//  DZHMACalculator.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCalculatorBase.h"

@interface DZHMACalculator : DZHCalculatorBase<DZHDataTraveler>

@property (nonatomic) int MADay;

@property (nonatomic) float MAValue;

- (instancetype)initWithMADay:(int)MADay;

- (void)reset;

- (float)technicalIndexesTravelWithModel:(id<DZHDrawingModel>)model atIndex:(NSInteger)index;

@end

