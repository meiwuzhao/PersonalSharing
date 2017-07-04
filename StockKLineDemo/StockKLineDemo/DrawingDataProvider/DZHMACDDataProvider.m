//
//  DZHMACDDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHMACDDataProvider.h"
#import "DZHMACDCalculator.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"
#import "DZHCurveItem.h"

@interface DZHMACDDataProvider ()

@property (nonatomic) float max;
@property (nonatomic) float min;

@end

@implementation DZHMACDDataProvider
{
    DZHCurveItem                          *_fast;
    DZHCurveItem                          *_slow;
}

@synthesize context         = _context;
@synthesize colorProvider   = _colorProvider;

- (id)init
{
    if (self = [super init])
    {
        _macdCal                        = [[DZHMACDCalculator alloc] initWithEMAFastDay:12 slowDay:26 difDay:9];
        
        _fast                           = [[DZHCurveItem alloc] init];
        _slow                           = [[DZHCurveItem alloc] init];
    }
    return self;
}

#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_macdCal travelerBeginAtIndex:index];
    }
    [_macdCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
    {
        self.max                = .0;
        self.min                = .0;
    }
    
    float max                   = MAX(MAX(data.DIF, data.DEA), data.MACD);
    float min                   = MIN(MIN(data.DIF, data.DEA), data.MACD);
    if (lastData == nil)
    {
        self.max                = max;
        self.min                = min;
    }
    else
    {
        if (_max < max)
            self.max            = max;
        
        if (_min > min)
        {
            self.min            = min;
        }
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
    entity.labelText            = [NSString stringWithFormat:@"%.2f",(_max + _min) * .5];
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
    NSUInteger startIndex       = context.fromIndex;
    NSUInteger endIndex         = context.toIndex;
    NSArray *klines             = context.datas;
    NSMutableArray *datas       = [NSMutableArray array];
    
    CGFloat macd,x;
    DZHDrawingItemModel *entity;
    
    CGFloat y0                  = [DZHDrawingUtil locationYForValue:0 withMax:_max min:_min top:top bottom:bottom];
    
    for (NSUInteger i = startIndex; i <= endIndex; i++)
    {
        entity                  = [klines objectAtIndex:i];
        MACDType type           = entity.MACD > 0 ? MACDTypePositive : MACDTypeNegative;
        macd                    = [DZHDrawingUtil locationYForValue:entity.MACD withMax:_max min:_min top:top bottom:bottom];
        
        x                       = [context centerLocationForIndex:i];
        entity.barRect          = CGRectMake(x, macd, 1., y0 - macd == 0 ? 1. : y0 - macd);//最小高度为1
        entity.barFillColor     = [_colorProvider colorForMACDType:type];
        [datas addObject:entity];
    }
    return datas;
}

- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom
{
    NSUInteger startIndex   = context.fromIndex;
    NSUInteger endIndex     = context.toIndex;
    NSArray *klines         = context.datas;
    NSInteger count         = endIndex - startIndex + 1;
    
    DZHDrawingItemModel *entity;
    
    CGPoint *fastPoints     = malloc(sizeof(CGPoint) * count);
    CGPoint *slowPoints     = malloc(sizeof(CGPoint) * count);
    for (NSInteger i = 0,j = startIndex; i < count; i ++,j++)
    {
        entity              = [klines objectAtIndex:j];
        fastPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.DIF withMax:_max min:_min top:top bottom:bottom]);
        
        slowPoints[i]       = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.DEA withMax:_max min:_min top:top bottom:bottom]);
    }
    
    [_fast setPoints:fastPoints withCount:count];
    [_slow setPoints:slowPoints withCount:count];
    
    _fast.color             = [_colorProvider colorForMACDLineType:MACDLineTypeFast];
    _slow.color             = [_colorProvider colorForMACDLineType:MACDLineTypeSlow];
    
    free(fastPoints);
    free(slowPoints);
    
    return @[_fast,_slow];
}

@end

