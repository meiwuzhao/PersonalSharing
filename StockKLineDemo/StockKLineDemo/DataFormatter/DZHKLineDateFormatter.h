//
//  DZHKLineDateFormatter.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZHKLineDateFormatter : NSFormatter

- (int)monthOfDate:(int)date;

- (int)yearMonthOfDate:(int)date;

@end
