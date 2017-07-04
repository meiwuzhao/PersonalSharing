//
//  DZHKLineEntity.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DZHKLineEntity : NSObject<NSCoding>

@property (nonatomic) int date; // K线时间
@property (nonatomic) int open; // 开盘价
@property (nonatomic) int high; // 最高价
@property (nonatomic) int low;  // 最低价
@property (nonatomic) int close;    // 收盘价
@property (nonatomic) int vol;

@end
