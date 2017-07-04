//
//  DZHKLineDataSource.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDataProvider.h"
#import "DZHDrawing.h"

typedef enum
{
    DrawingTagsTopAxisX,
    DrawingTagsTopAxisY,
    DrawingTagsTopMain,
    DrawingTagsTopExtend,
    
    DrawingTagsBottomAxisX,
    DrawingTagsBottomAxisY,
    DrawingTagsBottomMain,
    DrawingTagsBottomExtend,
}DrawingTags;

@interface DZHKLineDataSource : NSObject<DZHDrawingDataSource,DZHDrawingDelegate>


@property (nonatomic, retain) NSDictionary *MAConfigs;/**k线、量线移动平均线配置 {周期:颜色}*/

@property (nonatomic, retain) NSArray *klines;

@property (nonatomic, retain) id<DZHDataProviderProtocol> kLineDataProvider;

@property (nonatomic, retain) id<DZHDataProviderProtocol> indexDataProvider;

@property (nonatomic, retain)id<DZHDataProviderContextProtocol> context;

- (void)reloadTecIndexData;

@end
