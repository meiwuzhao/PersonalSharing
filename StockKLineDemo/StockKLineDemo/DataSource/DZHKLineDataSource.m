//
//  DZHKLineDataSource.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineDataSource.h"
#import "DZHDrawingItemModel.h"
#import "DZHDataProviderContext.h"
#import "DZHDrawing.h"

@interface DZHKLineDataSource ()

@end

@implementation DZHKLineDataSource

- (void)setKlines:(NSArray *)klines
{
    if (_klines != klines)
    {
        NSInteger idx                       = 0;
        
        NSMutableArray *datas               = [[NSMutableArray alloc] init];
        DZHDrawingItemModel *lastModel      = nil;
        DZHDrawingItemModel *model          = nil;
        
        for (DZHKLineEntity *entity in klines)
        {
            model                           = [[DZHDrawingItemModel alloc] initWithOriginData:entity];
            [datas addObject:model];
            
            [_kLineDataProvider setupPropertyWhenTravelLastData:lastModel currentData:model index:idx];
            [_indexDataProvider setupPropertyWhenTravelLastData:lastModel currentData:model index:idx];
            
            lastModel          = model;
            idx ++;
        }
        
        _klines                             = datas;
        _context.datas                      = datas;
        _context.itemCount                  = idx;
    }
}

- (void)reloadTecIndexData
{
    DZHDrawingItemModel *lastModel      = nil;
    NSInteger idx                       = 0;
    
    for (DZHDrawingItemModel *model in _klines)
    {
        [_indexDataProvider setupPropertyWhenTravelLastData:lastModel currentData:model index:idx];
        
        lastModel          = model;
        idx ++;
    }
}

#pragma mark - DZHDrawingDelegate

- (void)prepareDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{

}

- (void)completeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    [_context calculateFromAndToIndexWithRect:rect];
    NSInteger from                      = _context.fromIndex;
    NSInteger to                        = _context.toIndex;
    DZHDrawingItemModel *lastModel      = nil;
    DZHDrawingItemModel *model          = nil;
    
    for (NSInteger i = from; i <= to; i++)
    {
        model                          = [_klines objectAtIndex:i];
        
        [_kLineDataProvider setupMaxAndMinWhenTravelLastData:lastModel currentData:model index:i];
        [_indexDataProvider setupMaxAndMinWhenTravelLastData:lastModel currentData:model index:i];
        
        lastModel          = model;
    }
}


#pragma mark - DZHDrawingDataSource

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect
{
    CGFloat top         = CGRectGetMinY(rect);
    CGFloat bottom      = CGRectGetMaxY(rect);
    switch (drawing.drawingTag)
    {
        case DrawingTagsTopAxisX:
            return [_kLineDataProvider axisXDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsTopAxisY:
            return [_kLineDataProvider axisYDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsTopMain:
            return [_kLineDataProvider itemDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsBottomAxisX:
            return [_kLineDataProvider axisXDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsBottomAxisY:
            return [_indexDataProvider axisYDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsBottomMain:
            return [_indexDataProvider itemDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsTopExtend:
            return [_kLineDataProvider extendDatasWithContext:_context top:top bottom:bottom];
        case DrawingTagsBottomExtend:
            return [_indexDataProvider extendDatasWithContext:_context top:top bottom:bottom];
        default:
            return nil;
    }
}

@end

