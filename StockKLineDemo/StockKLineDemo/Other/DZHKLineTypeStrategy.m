//
//  DZHKLineTypeStrategy.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineTypeStrategy.h"
#import "DZHDrawingModels.h"

@implementation DZHKLineTypeStrategy

- (void)travelerWithLastData:(id<DZHKLineModel>)last currentData:(id<DZHKLineModel>)currentData index:(NSInteger)index
{
    if (currentData.open < currentData.close)
        currentData.type        = KLineTypePositive;
    else if (currentData.open > currentData.close)
        currentData.type        = KLineTypeNegative;
    else if (last.close < currentData.open)  // 当天开盘 == 收盘，开盘 > 昨收
        currentData             = KLineTypePositive;
    else if (last.close > currentData.open) // 当天开盘 == 收盘，开盘 < 昨收
        currentData.type        = KLineTypeNegative;
    else // 当天开盘 == 收盘，开盘 == 昨收
        currentData.type        = KLineTypeCross;
}

@end

