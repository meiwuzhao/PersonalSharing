//
//  DZHDataProviderBase.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDataProvider.h"

@interface DZHDataProviderBase : NSObject<DZHDataProviderProtocol>

- (int)cycleForType:(NSInteger)type;

@end

