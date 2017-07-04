//
//  DZHKDJDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKDJDataProvider.h"
#import "DZHKDJCalculator.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"
#import "DZHCurveItem.h"

@interface DZHKDJDataProvider ()

@property (nonatomic) float max;
@property (nonatomic) float min;

@end

@implementation DZHKDJDataProvider
{
    DZHCurveItem                          *_kModel;
    DZHCurveItem                          *_dModel;
    DZHCurveItem                          *_jModel;
}

@synthesize context             = _context;
@synthesize colorProvider       = _colorProvider;

- (instancetype)init
{
    if (self = [super init])
    {
        _kdjCal                         = [[DZHKDJCalculator alloc] initWithKDay:3 DDay:3 rsvDay:9];
        
        _kModel                         = [[DZHCurveItem alloc] init];
        _dModel                         = [[DZHCurveItem alloc] init];
        _jModel                         = [[DZHCurveItem alloc] init];
    }
    return self;
}



#pragma mark - DZHDataProviderProtocol

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_kdjCal travelerBeginAtIndex:index];
    }
    [_kdjCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
    {
        self.max                = .0;
        self.min                = .0;
    }
    
    float max                   = MAX(MAX(data.K, data.D), data.J);
    float min                   = MIN(MIN(data.K, data.D), data.J);
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
    entity.labelText            = [NSString stringWithFormat:@"%.1f",_min];
    entity.notDrawLine          = YES;
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, round(bottom - (bottom - top) * .5));
    entity.labelText            = [NSString stringWithFormat:@"%.1f",roundf((_max + _min) * .5)];
    entity.dashLengths          = @[@3.f,@2.f];
    [datas addObject:entity];
    
    entity                      = [[DZHAxisItem alloc] init];
    entity.location             = CGPointMake(.0, top);
    entity.labelText            = [NSString stringWithFormat:@"%.1f",_max];
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
    NSInteger count         = endIndex - startIndex + 1;
    
    DZHDrawingItemModel *entity;
    
    CGPoint *kPoints        = malloc(sizeof(CGPoint) * count);
    CGPoint *dPoints        = malloc(sizeof(CGPoint) * count);
    CGPoint *jPoints        = malloc(sizeof(CGPoint) * count);
    for (NSInteger i = 0,j = startIndex; i < count; i ++,j++)
    {
        entity              = [klines objectAtIndex:j];
        kPoints[i]          = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.K withMax:_max min:_min top:top bottom:bottom]);
        
        dPoints[i]          = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.D withMax:_max min:_min top:top bottom:bottom]);
        
        jPoints[i]          = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.J withMax:_max min:_min top:top bottom:bottom]);
    }
    
    [_kModel setPoints:kPoints withCount:count];
    [_dModel setPoints:dPoints withCount:count];
    [_jModel setPoints:jPoints withCount:count];
    
    _kModel.color             = [_colorProvider colorForKDJType:KDJLineTypeK];
    _dModel.color             = [_colorProvider colorForKDJType:KDJLineTypeD];
    _jModel.color             = [_colorProvider colorForKDJType:KDJLineTypeJ];
    
    free(kPoints);
    free(dPoints);
    free(jPoints);
    
    return @[_kModel,_dModel,_jModel];
}

@end
