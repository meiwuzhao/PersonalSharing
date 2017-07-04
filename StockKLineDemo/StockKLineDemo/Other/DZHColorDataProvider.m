//
//  DZHColorDataProvider.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHColorDataProvider.h"
#import "UIColor+RGB.h"

@implementation DZHColorDataProvider
{
    UIColor                         *_positiveColor;
    UIColor                         *_negativeColor;
    UIColor                         *_crossColor;
    
    UIColor                         *_cycleFiveColor;
    UIColor                         *_cycleTenColor;
    UIColor                         *_cycleTwentyColor;
    UIColor                         *_cycleThirtyColor;
}

- (id)init
{
    if (self = [super init])
    {
        _positiveColor                  = [UIColor colorFromRGB:0xf92a27];
        _negativeColor                  = [UIColor  colorFromRGB:0x2b9826];
        _crossColor                     = [UIColor grayColor];
        
        _cycleFiveColor                 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        _cycleTenColor                  = [UIColor colorWithRed:1.0 green:1.0 blue:0.0 alpha:1.0];
        _cycleTwentyColor               = [UIColor colorWithRed:0.87 green:0.23 blue:0.84 alpha:1.0];
        _cycleThirtyColor               = [UIColor colorWithRed:0.0 green:1.0 blue:0.0 alpha:1.0];
    }
    return self;
}


- (UIColor *)colorForKLineType:(KLineType)kType
{
    switch (kType) {
        case KLineTypePositive:
            return _positiveColor;
        case KLineTypeNegative:
            return _negativeColor;
        case KLineTypeCross:
            return _crossColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForMACycle:(KLineCycle)cycle
{
    switch (cycle)
    {
        case KLineCycleFive:
            return _cycleFiveColor;
        case KLineCycleTen:
            return _cycleTenColor;
        case KLineCycleTwenty:
            return _cycleTwentyColor;
        case KLineCycleThirty:
            return _cycleThirtyColor;
        default:
            return nil;;
    }
}

- (UIColor *)colorForVolumeType:(VolumeType)volumeType
{
    switch (volumeType)
    {
        case VolumeTypePositive:
            return _positiveColor;
        case VolumeTypeNegative:
            return _negativeColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForVolumeMACycle:(KLineCycle)cycle
{
    return [self colorForMACycle:cycle];
}

- (UIColor *)colorForMACDLineType:(MACDLineType)type
{
    switch (type)
    {
        case MACDLineTypeFast:
            return _cycleFiveColor;
        case MACDLineTypeSlow:
            return _cycleTenColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForMACDType:(MACDType)type
{
    switch (type)
    {
        case MACDTypePositive:
            return _positiveColor;
        case MACDTypeNegative:
            return _negativeColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForKDJType:(KDJLineType)KDJType
{
    switch (KDJType)
    {
        case KDJLineTypeK:
            return _cycleFiveColor;
        case KDJLineTypeD:
            return _cycleTenColor;
        case KDJLineTypeJ:
            return _cycleTwentyColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForRSIType:(RSILineType)KDJType
{
    switch (KDJType)
    {
        case RSILineType1:
            return _cycleFiveColor;
        case RSILineType2:
            return _cycleTenColor;
        case RSILineType3:
            return _cycleTwentyColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForWRType:(WRLineType)WRType
{
    switch (WRType)
    {
        case WRLineType1:
            return _cycleFiveColor;
        case WRLineType2:
            return _cycleTenColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForBIASType:(BIASLineType)BIASType
{
    switch (BIASType)
    {
        case BIASLineType1:
            return _cycleFiveColor;
        case BIASLineType2:
            return _cycleTenColor;
        case BIASLineType3:
            return _cycleTwentyColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForCCILine
{
    return _cycleFiveColor;
}

- (UIColor *)colorForDMAType:(DMALineType)DMAType
{
    switch (DMAType)
    {
        case DMALineTypeDDD:
            return _cycleFiveColor;
        case DMALineTypeAMA:
            return _cycleTenColor;
        default:
            return nil;
    }
}

- (UIColor *)colorForBOLLType:(BOLLLineType)BOLLType
{
    switch (BOLLType)
    {
        case BOLLLineTypeUPP:
            return _cycleTenColor;
        case BOLLLineTypeMID:
            return _cycleFiveColor;
        case BOLLLineTypeLOW:
            return _cycleTwentyColor;
        default:
            return nil;
    }
}

@end

