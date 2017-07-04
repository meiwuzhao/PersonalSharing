//
//  DZHRSIDataProvider.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDataProviderBase.h"

@class DZHRSICalculator;

@interface DZHRSIDataProvider : DZHDataProviderBase<DZHDataProviderProtocol>
{
    DZHRSICalculator            *_rsiCal;
}

@end

