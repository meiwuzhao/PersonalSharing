//
//  DZHVolumeTypeStrategy.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHVolumeTypeStrategy.h"
#import "DZHDrawingModels.h"

@implementation DZHVolumeTypeStrategy

- (void)travelerWithLastData:(id<DZHVolumeModel>)last currentData:(id<DZHVolumeModel>)currentData index:(NSInteger)index
{
    if (last == nil)
    {
        currentData.volumeType   = currentData.close >= currentData.open ? VolumeTypePositive : VolumeTypeNegative;
    }
    else if (currentData.close >= last.close)
    {
        currentData.volumeType  = VolumeTypePositive;
    }
    else
    {
        currentData.volumeType  = VolumeTypeNegative;
    }
}

@end
