//
//  DZHWRDataProvider.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDataProviderBase.h"

@class DZHWRCalculator;

@interface DZHWRDataProvider : DZHDataProviderBase<DZHDataProviderProtocol>
{
    DZHWRCalculator                 *_wrCal;
}

@end
