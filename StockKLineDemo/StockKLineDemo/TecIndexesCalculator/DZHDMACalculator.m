//
//  DZHDMACalculator.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDMACalculator.h"
#import "DZHMACalculator.h"

static float sumf(float *arr, int count)
{
    float sum       = 0;
    for (int i = 0 ; i < count; i++)
    {
        sum         += arr[i];
    }
    return sum;
}

@implementation DZHDMACalculator
{
    DZHMACalculator             *_shortMACal;
    DZHMACalculator             *_longMACal;
    
    float                       *_DDDs;
}

- (instancetype)initWithDMAShortDay:(int)shortDay longDay:(int)longDay
{
    if (self = [super init])
    {
        NSParameterAssert(shortDay < longDay);
        
        self.shortDay           = shortDay;
        self.longDay            = longDay;
        
        _shortMACal             = [[DZHMACalculator alloc] initWithMADay:shortDay];
        _longMACal              = [[DZHMACalculator alloc] initWithMADay:longDay];
        
        _DDDs                   = malloc(sizeof(float) * 10);
    }
    return self;
}

- (void)dealloc
{
    free(_DDDs);
}

- (void)travelerBeginAtIndex:(NSInteger)index
{
    [_shortMACal reset];
    [_longMACal reset];
    
    memset(_DDDs, 0, sizeof(float) * 10);
}

- (void)travelerWithLastData:(id<DZHDMAModel>)last currentData:(id<DZHDMAModel>)currentData index:(NSInteger)index
{
    int M                       = 10;
    
    float shortValue            = [_shortMACal technicalIndexesTravelWithModel:currentData atIndex:index];
    float longValue             = [_longMACal technicalIndexesTravelWithModel:currentData atIndex:index];
    float DDD                   = .0;
    
    if (index >= _longDay)
    {
        DDD                     = shortValue - longValue;
        currentData.DDD         = DDD;
    }
    
    int idx                     = index % M;
    _DDDs[idx]                  = DDD;
    
    if (index < _longDay + M)
    {
        currentData.AMA         = .0;
    }
    else
    {
        currentData.AMA         = sumf(_DDDs, M) / M;
    }
    printf("fMas:%.2f fMal:%.2f AMA:%.2f  DDD:%.2f \n",shortValue,longValue,currentData.AMA,currentData.DDD);
}

@end

