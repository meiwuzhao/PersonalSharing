//
//  DZHKLineEntity.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineEntity.h"

@implementation DZHKLineEntity

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInt:_date forKey:@"date"];
    [aCoder encodeInt:_open forKey:@"open"];
    [aCoder encodeInt:_high forKey:@"high"];
    [aCoder encodeInt:_low forKey:@"low"];
    [aCoder encodeInt:_close forKey:@"close"];
    [aCoder encodeInt:_vol forKey:@"vol"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        _date       = [aDecoder decodeIntForKey:@"date"];
        _open       = [aDecoder decodeIntForKey:@"open"];
        _high       = [aDecoder decodeIntForKey:@"high"];
        _low        = [aDecoder decodeIntForKey:@"low"];
        _close      = [aDecoder decodeIntForKey:@"close"];
        _vol        = [aDecoder decodeIntForKey:@"vol"];
    }
    return self;
}

@end
