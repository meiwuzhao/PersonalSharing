//
//  DZHDrawingItemModel.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawingItemModel.h"

@implementation DZHDrawingItemModel

@synthesize precision;
@synthesize type;
@synthesize volumeType;
@synthesize solidRect;
@synthesize stickRect;
@synthesize stickColor;
@synthesize barRect;
@synthesize barFillColor;
@synthesize linePoints;
@synthesize lineColor;
@synthesize DIF;
@synthesize DEA;
@synthesize MACD;
@synthesize K;
@synthesize D;
@synthesize J;
@synthesize RSI1;
@synthesize RSI2;
@synthesize RSI3;
@synthesize WR1;
@synthesize WR2;
@synthesize BIAS1;
@synthesize BIAS2;
@synthesize BIAS3;
@synthesize CCI;
@synthesize DDD;
@synthesize AMA;
@synthesize UPP;
@synthesize MID;
@synthesize LOW;

- (instancetype)initWithOriginData:(DZHKLineEntity *)originData
{
    if (self = [super init])
    {
        self.originData         = originData;
        self.precision          = 2;
        _extendData             = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    if (linePoints != NULL)
        free(linePoints);
}

- (float)open
{
    return _originData.open * .01;
}

- (float)close
{
    return _originData.close * .01;
}

- (float)high
{
    return _originData.high * .01;
}

- (float)low
{
    return _originData.low * .01;
}

- (int)date
{
    return _originData.date;
}

- (int)volume
{
    return _originData.vol;
}

- (void)setMA:(float)ma withCycle:(int)cycle
{
    [_extendData setObject:[NSNumber numberWithFloat:ma] forKey:[NSString stringWithFormat:@"MA%d",cycle]];
}

- (float)MAWithCycle:(int)cycle
{
    return [[_extendData objectForKey:[NSString stringWithFormat:@"MA%d",cycle]] floatValue];
}

- (void)setVolumeMA:(int)ma withCycle:(int)cycle
{
    [_extendData setObject:@(ma) forKey:[NSString stringWithFormat:@"VolMA%d",cycle]];
}

- (int)volumeMAWithCycle:(int)cycle
{
    return [[_extendData objectForKey:[NSString stringWithFormat:@"VolMA%d",cycle]] intValue];
}

//美国线 由3条线，6个点
- (void)setLinePoints:(CGPoint *)points
{
    if (linePoints != NULL)
        free(linePoints);
    
    size_t size             = sizeof(CGPoint) * kOHLCPointCount;
    linePoints              = malloc(size);
    memcpy(linePoints, points, size);
}

@end

