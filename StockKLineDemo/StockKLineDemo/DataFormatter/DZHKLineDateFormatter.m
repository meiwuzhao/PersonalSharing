//
//  DZHKLineDateFormatter.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineDateFormatter.h"

@implementation DZHKLineDateFormatter

- (int)monthOfDate:(int)date
{
    return (date % 10000)/100;
}

- (int)yearMonthOfDate:(int)date
{
    return date/100;
}

- (NSString *)stringForObjectValue:(id)obj
{
    int date    = [obj intValue];
    int year    = date / 10000;
    int month   = (date % 10000)/100;
    return [NSString stringWithFormat:@"%d/%02d",year,month];
}

- (BOOL)getObjectValue:(out id *)obj forString:(NSString *)string errorDescription:(out NSString **)error
{
    int year        = [[string substringWithRange:NSMakeRange(0, 4)] intValue];
    int month       = [[string substringWithRange:NSMakeRange(5, 2)] intValue];
    
    *obj            = @(year * 1000 + month * 100);
    return YES;
}


@end
