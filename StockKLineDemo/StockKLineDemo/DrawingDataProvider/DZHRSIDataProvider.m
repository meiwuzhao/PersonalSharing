//
//  DZHRSIDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHRSIDataProvider.h"
#import "DZHRSICalculator.h"
#import "DZHCurveItem.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"

@interface DZHRSIDataProvider ()

@property (nonatomic) float max;
@property (nonatomic) float min;
@property (nonatomic, retain) NSArray *rsiModels;

@end

@implementation DZHRSIDataProvider

@synthesize context             = _context;
@synthesize colorProvider       = _colorProvider;

- (instancetype)init
{
    if (self = [super init])
    {
        _rsiCal                         = [[DZHRSICalculator alloc] initWithRSI1:[self cycleForType:RSILineType1] RSI2:[self cycleForType:RSILineType2] RSI3:[self cycleForType:RSILineType3]];
        
        DZHCurveItem *rsi1Model         = [[DZHCurveItem alloc] init];
        DZHCurveItem *rsi2Model         = [[DZHCurveItem alloc] init];
        DZHCurveItem *rsi3Model         = [[DZHCurveItem alloc] init];
        
        self.rsiModels                  = @[rsi1Model,rsi2Model,rsi3Model];

        
        self.max                        = 100;
        self.min                        = 0;
    }
    return self;
}

- (int)cycleForType:(NSInteger)type
{
    if (type == RSILineType1)
        return 6;
    else if (type == RSILineType2)
        return 12;
    else if (type == RSILineType3)
        return 24;
    return 0;
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_rsiCal travelerBeginAtIndex:index];
    }
    [_rsiCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHAxisItem *entity       = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, bottom);
    entity.labelText            = @"0";
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, round(bottom - (bottom - top) * .5));
    entity.labelText            = @"50";
    entity.dashLengths          = @[@3.f,@2.f];
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = @"100";
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    
    return datas;
}

- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    return nil;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex   = context.fromIndex;
    NSUInteger endIndex     = context.toIndex;
    NSArray *klines         = context.datas;
    NSMutableArray *datas   = [NSMutableArray array];
    DZHDrawingItemModel *entity;
    
    int idx                 = 0;
    for (DZHCurveItem *model in _rsiModels)
    {
        NSInteger begin     = [self beginOfIndex:startIndex indexCycle:[self cycleForType:idx]];
        NSInteger count     = endIndex - begin + 1;
        
        if (count <= 0)
            continue;
        [datas addObject:model];
        
        CGPoint *points     = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = begin; i < count; i ++,j++)
        {
            entity          = [klines objectAtIndex:j];
            
            float value;
            if (idx == 0)
                value       = entity.RSI1;
            else if (idx == 1)
                value       = entity.RSI2;
            else
                value       = entity.RSI3;
            
            points[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:value withMax:_max min:_min top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        model.color         = [_colorProvider colorForRSIType:idx];
        free(points);
        
        idx ++;
    }
    
    return datas;
}

@end
