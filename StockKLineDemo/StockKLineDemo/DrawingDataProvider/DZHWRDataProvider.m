//
//  DZHWRDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHWRDataProvider.h"
#import "DZHWRCalculator.h"
#import "DZHCurveItem.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"

@interface DZHWRDataProvider ()

@property (nonatomic) float max;

@property (nonatomic) float min;

@property (nonatomic, retain) NSArray *models;

@end

@implementation DZHWRDataProvider

- (instancetype)init
{
    if (self = [super init])
    {
        _wrCal                          = [[DZHWRCalculator alloc] initWithWRDay1:[self cycleForType:WRLineType1] WRDay2:[self cycleForType:WRLineType2]];
        
        NSMutableArray *arr             = [NSMutableArray array];
        
        DZHCurveItem *model             = [[DZHCurveItem alloc] init];
        [arr addObject:model];
        
        model                           = [[DZHCurveItem alloc] init];
        [arr addObject:model];
        
        self.models                     = arr;
    }
    return self;
}


- (int)cycleForType:(NSInteger)type
{
    if (type == WRLineType1)
        return 14;
    else if (type == WRLineType2)
        return 28;
    return 0;
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_wrCal travelerBeginAtIndex:index];
    }
    [_wrCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
    {
        self.max                = .0;
        self.min                = .0;
    }
    
    if (index < [self cycleForType:WRLineType1])
        return;
    
    float max, min;
    if (index < [self cycleForType:WRLineType2])
    {
        max                     = data.WR1;
        min                     = data.WR1;
    }
    else
    {
        max                     = MAX(data.WR1, data.WR2);
        min                     = MIN(data.WR1, data.WR2);
    }
    
    if (_max == 0 && _min == 0)
    {
        self.max                = max;
        self.min                = min;
    }
    else
    {
        if (_max < max)
            self.max            = max;
        
        if (_min > min)
            self.min            = min;
    }
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHAxisItem *entity       = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, bottom);
    entity.labelText            = [NSString stringWithFormat:@"%.2f",_min];
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, round(bottom - (bottom - top) * .5));
    entity.labelText            = [NSString stringWithFormat:@"%.2f",(_max + _min) * .5];;
    entity.dashLengths          = @[@3.f,@2.f];
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = [NSString stringWithFormat:@"%.2f",_max];
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
    for (DZHCurveItem *model in self.models)
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
                value       = entity.WR1;
            else
                value       = entity.WR2;
            
            points[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:value withMax:_max min:_min top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        model.color         = [self.colorProvider colorForWRType:idx];
        free(points);
        
        idx ++;
    }
    
    return datas;
}

@end

