//
//  DZHDrawingDefine.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#ifndef DZHDrawable_DZHDrawingDefine_h
#define DZHDrawable_DZHDrawingDefine_h

#define kOHLCPointCount     6 //美国线点个数

typedef enum
{
    KLineTypePositive   = 0, //阳线
    KLineTypeNegative   = 1, //阴线
    KLineTypeCross      = 2, //十字线
}KLineType;

typedef enum
{
    KLineCycleFive      = 5,
    KLineCycleTen       = 10,
    KLineCycleTwenty    = 20,
    KLineCycleThirty    = 30,
}KLineCycle;

typedef enum
{
    VolumeTypePositive,
    VolumeTypeNegative,
}VolumeType;

typedef enum
{
    MACDLineTypeFast,
    MACDLineTypeSlow,
}MACDLineType;

typedef enum
{
    MACDTypePositive,
    MACDTypeNegative,
}MACDType;

typedef enum
{
    KDJLineTypeK,
    KDJLineTypeD,
    KDJLineTypeJ,
}KDJLineType;

typedef enum
{
    RSILineType1,
    RSILineType2,
    RSILineType3,
}RSILineType;

typedef enum
{
    WRLineType1,
    WRLineType2,
}WRLineType;

typedef enum
{
    BIASLineType1,
    BIASLineType2,
    BIASLineType3,
}BIASLineType;

typedef enum
{
    DMALineTypeDDD,
    DMALineTypeAMA,
}DMALineType;

typedef enum
{
    BOLLLineTypeUPP,
    BOLLLineTypeMID,
    BOLLLineTypeLOW,
}BOLLLineType;

#endif
