//
//  DZHDataTraveler.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

@protocol DZHDataTraveler <NSObject>

@optional

- (void)travelerBeginAtIndex:(NSInteger)index;

- (void)travelerWithLastData:(id)last currentData:(id)currentData index:(NSInteger)index;

- (void)travelerEndAtIndex:(NSInteger)index;

@end
