//
//  DZHCCIDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHCCIDataProvider.h"
#import "DZHCurveItem.h"
#import "DZHCCICalculator.h"
#import "DZHDrawingItemModel.h"
#import "DZHAxisItem.h"
#import "DZHDrawingUtil.h"

@interface DZHCCIDataProvider ()

@property (nonatomic) float max;

@property (nonatomic) float min;

@end

@implementation DZHCCIDataProvider
{
    DZHCurveItem                          *_model;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _cciCal                         = [[DZHCCICalculator alloc] initWithCCIDay:[self cycleForType:0]];
        
        _model                          = [[DZHCurveItem alloc] init];
    }
    return self;
}



#pragma mark - DZHDataProviderProtocol

- (int)cycleForType:(NSInteger)type
{
    return 14;
}

- (void)setupPropertyWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)curData index:(NSInteger)index
{
    if (lastData == nil)    //遍历起始，重置数据
    {
        [_cciCal travelerBeginAtIndex:index];
    }
    [_cciCal travelerWithLastData:lastData currentData:curData index:index];
}

- (void)setupMaxAndMinWhenTravelLastData:(DZHDrawingItemModel *)lastData currentData:(DZHDrawingItemModel *)data index:(NSInteger)index
{
    if (lastData == nil)
    {
        self.max                = .0;
        self.min                = .0;
    }
    
    if (index < [self cycleForType:0])
        return;
    
    float cci                   = data.CCI;
    if (_max == 0 && _min == 0)
    {
        self.max                = cci;
        self.min                = cci;
    }
    else
    {
        if (_max < cci)
            self.max            = cci;
        
        if (_min > cci)
            self.min            = cci;
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
    
    NSInteger begin         = [self beginOfIndex:startIndex indexCycle:[self cycleForType:0]];
    NSInteger count         = endIndex - begin + 1;
    
    if (count <= 0)
        return datas;
    
    CGPoint *points         = malloc(sizeof(CGPoint) * count);
    for (NSInteger i = 0,j = begin; i < count; i ++,j++)
    {
        entity              = [klines objectAtIndex:j];
        points[i]           = CGPointMake([context centerLocationForIndex:j], [DZHDrawingUtil locationYForValue:entity.CCI withMax:_max min:_min top:top bottom:bottom]);
    }
    [_model setPoints:points withCount:count];
    _model.color            = [self.colorProvider colorForCCILine];
    free(points);
    
    [datas addObject:_model];
    
    return datas;
}

@end
