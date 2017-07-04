//
//  DZHVolumeDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHVolumeDataProvider.h"
#import "DZHVolumeMACalculator.h"
#import "DZHCurveItem.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"
#import "DZHVolumeTypeStrategy.h"

@interface DZHVolumeDataProvider ()

@property (nonatomic, retain) NSArray *volumeMAModels;

@property (nonatomic, retain) NSArray *volumeMACalculators;

@property (nonatomic, retain) NSArray *MACycle;

@property (nonatomic) int maxVolume;

@end

@implementation DZHVolumeDataProvider
{
    DZHVolumeTypeStrategy            *_volTypeStrategy;
}

@synthesize context         = _context;
@synthesize colorProvider   = _colorProvider;

- (id)init
{
    if (self = [super init])
    {
        _volTypeStrategy        = [[DZHVolumeTypeStrategy alloc] init];
        
        self.MACycle            = @[@(KLineCycleFive),@(KLineCycleTen),@(KLineCycleTwenty),@(KLineCycleThirty)];
    }
    return self;
}

- (void)setMACycle:(NSArray *)MACycle
{
    if (_MACycle != MACycle)
    {
        _MACycle                            = [NSArray arrayWithArray:MACycle];
        
        NSMutableArray *volCals             = [NSMutableArray array];
        NSMutableArray *volModels           = [NSMutableArray array];
        for (NSNumber *cycle in MACycle)
        {
            int v                           = [cycle intValue];
            DZHVolumeMACalculator *volCal   = [[DZHVolumeMACalculator alloc] initWithMACycle:v];
            [volCals addObject:volCal];
            
            DZHCurveItem *model             = [[DZHCurveItem alloc] init];
            model.isBezier                  = YES;
            [volModels addObject:model];
        }
        self.volumeMACalculators            = volCals;
        self.volumeMAModels                 = volModels;
    }
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        for (DZHVolumeMACalculator *calculator in _volumeMACalculators)
        {
            [calculator travelerBeginAtIndex:index];
        }
    }
    
    for (DZHVolumeMACalculator *calculator in _volumeMACalculators)
    {
        [calculator travelerWithLastData:lastData currentData:curData index:index];
    }
    
    [_volTypeStrategy travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
        _maxVolume                          = data.volume;
    else if (data.volume > _maxVolume)
        _maxVolume                          = data.volume;
    
    for (NSNumber *cycle in _MACycle)
    {
        int volMA                           = [data volumeMAWithCycle:[cycle intValue]];
        
        if (volMA > _maxVolume)
            _maxVolume                      = volMA;
    }
}

- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHAxisItem *entity       = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, bottom);
    entity.labelText            = @"万手";
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = [NSString stringWithFormat:@"%.1f",(float)self.maxVolume/10000];
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    
    return datas;
}

- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSArray *klines             = context.datas;
    if (!klines)
        return nil;
    
    NSUInteger startIndex       = context.fromIndex;
    NSUInteger endIndex         = context.toIndex;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat vol,x;
    DZHDrawingItemModel *entity;
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        vol                     = [DZHDrawingUtil locationYForValue:entity.volume withMax:_maxVolume min:0 top:top bottom:bottom];
        x                       = [context locationForIndex:i];
        
        entity.barRect          = CGRectMake(x, vol, context.itemWidth, MAX(ABS(bottom - vol), 1.));
        entity.barFillColor     = [_colorProvider colorForVolumeType:entity.volumeType];
        [datas addObject:entity];
    }
    return datas;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex       = context.fromIndex;
    NSUInteger endIndex         = context.toIndex;
    NSArray *klines             = context.datas;
    NSMutableArray *datas       = [NSMutableArray array];
    
    DZHDrawingItemModel *entity;
    
    int idx                     = 0;
    for (DZHCurveItem *model in _volumeMAModels)
    {
        int cycle               = [[self.MACycle objectAtIndex:idx] intValue];
        model.color             = [_colorProvider colorForVolumeMACycle:cycle];
        
        NSInteger begin         = [self beginOfIndex:startIndex indexCycle:cycle - 1];
        NSInteger count         = endIndex - begin + 1;
        
        if (count <= 0)
            continue;
        [datas addObject:model];
        
        CGPoint *points         = malloc(sizeof(CGPoint) * count);
        for (NSInteger i = 0,j = begin; i < count; i ++,j++)
        {
            entity              = [klines objectAtIndex:j];
            points[i]           = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:[entity volumeMAWithCycle:cycle] withMax:_maxVolume min:0 top:top bottom:bottom]);
        }
        [model setPoints:points withCount:count];
        free(points);
        
        idx ++;
    }
    
    return datas;
}

@end
