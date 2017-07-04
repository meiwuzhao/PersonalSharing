//
//  DZHBIASDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHBIASDataProvider.h"
#import "DZHBIASCalculator.h"
#import "DZHCurveItem.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"

@interface DZHBIASDataProvider ()

@property (nonatomic, retain) NSArray *models;

@property (nonatomic) float max;

@property (nonatomic) float min;

@end

@implementation DZHBIASDataProvider
{
    DZHBIASCalculator                   *_calculator;
}

- (instancetype)init
{
    if (self = [super init])
    {
        _calculator                     = [[DZHBIASCalculator alloc] initWithBIASDay1:[self cycleForType:BIASLineType1] BIASDay2:[self cycleForType:BIASLineType2] BIASDay3:[self cycleForType:BIASLineType3]];
        
        
        DZHCurveItem *model1            = [[DZHCurveItem alloc] init];
        
        DZHCurveItem *model2            = [[DZHCurveItem alloc] init];
        
        DZHCurveItem *model3            = [[DZHCurveItem alloc] init];
        
        self.models                     = @[model1, model2, model3];

    }
    return self;
}



#pragma mark - DZHDataProviderProtocol

- (int)cycleForType:(NSInteger)type
{
    switch (type)
    {
        case BIASLineType1:
            return 6;
        case BIASLineType2:
            return 12;
        case BIASLineType3:
            return 24;
        default:
            return 0;
    }
}

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil) //遍历起始，重置数据
    {
        [_calculator travelerBeginAtIndex:index];
    }
    [_calculator travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
    {
        self.max                = .0;
        self.min                = .0;
    }
    
    float max, min;
    
    if (index < [self cycleForType:BIASLineType1])
        return;
    else if (index < [self cycleForType:BIASLineType2])
    {
        max                     = data.BIAS1;
        min                     = data.BIAS1;
    }
    else if (index < [self cycleForType:BIASLineType3])
    {
        max                     = MAX(data.BIAS1, data.BIAS2);
        min                     = MIN(data.BIAS1, data.BIAS2);
    }
    else
    {
        max                     = MAX(MAX(data.BIAS1, data.BIAS2), data.BIAS3);
        min                     = MIN(MIN(data.BIAS1, data.BIAS2), data.BIAS3);
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
    
    DZHAxisItem *entity         = [[DZHAxisItem alloc] init];
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
    NSInteger count         = endIndex - startIndex + 1;
    for (DZHCurveItem *model in self.models)
    {
        [datas addObject:model];
        
        CGPoint *points     = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = startIndex; i < count; i ++,j++)
        {
            entity          = [klines objectAtIndex:j];
            
            float value;
            if (idx == 0)
                value       = entity.BIAS1;
            else if (idx == 1)
                value       = entity.BIAS2;
            else
                value       = entity.BIAS3;
            
            points[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:value withMax:_max min:_min top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        model.color         = [self.colorProvider colorForBIASType:idx];
        free(points);
        
        idx ++;
    }
    
    return datas;
}

@end

