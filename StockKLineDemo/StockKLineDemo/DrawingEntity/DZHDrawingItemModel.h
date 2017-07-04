//
//  DZHDrawingItemModel.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineEntity.h"
#import "DZHDrawingItems.h"
#import "DZHDrawingModels.h"

@interface DZHDrawingItemModel : NSObject
<
DZHKLineItem,
DZHBarItem,
DZHOHLCItem,

DZHKLineModel,
DZHVolumeModel,
DZHMACDModel,
DZHKDJModel,
DZHRSIModel,
DZHWRModel,
DZHBIASModel,
DZHCCIModel,
DZHDMAModel,
DZHBOLLModel
>

@property (nonatomic, retain) DZHKLineEntity *originData;

@property (nonatomic, retain, readonly) NSMutableDictionary *extendData;

- (instancetype)initWithOriginData:(DZHKLineEntity *)originData;

@end
