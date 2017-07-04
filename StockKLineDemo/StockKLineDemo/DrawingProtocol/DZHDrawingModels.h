//
//  DZHDrawingModels.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

/**
 * 绘图数据模型接口，各种指标、均线为该接口子类
 */
@protocol DZHDrawingModel <NSObject>

@property (nonatomic) int precision;

- (float)open;

- (float)close;

- (float)high;

- (float)low;

- (int)date;

- (int)volume;

@end

/**
 * K线
 */
@protocol DZHKLineModel <DZHDrawingModel>

@property (nonatomic) KLineType type;

- (void)setMA:(float)ma withCycle:(int)cycle;

- (float)MAWithCycle:(int)cycle;

@end

/**
 * 成交量
 */
@protocol DZHVolumeModel <DZHDrawingModel>

@property (nonatomic) VolumeType volumeType;

- (void)setVolumeMA:(int)ma withCycle:(int)cycle;

- (int)volumeMAWithCycle:(int)cycle;

@end

/**
 * 指数平滑异同平均线
 */
@protocol DZHMACDModel <DZHDrawingModel>

@property (nonatomic) float DIF;

@property (nonatomic) float DEA;

@property (nonatomic) float MACD;

@end

/**
 * 随机指标
 */
@protocol DZHKDJModel <DZHDrawingModel>

@property (nonatomic) float K;

@property (nonatomic) float D;

@property (nonatomic) float J;

@end

/**
 * 相对强弱指标
 */
@protocol DZHRSIModel <DZHDrawingModel>

@property (nonatomic) float RSI1;

@property (nonatomic) float RSI2;

@property (nonatomic) float RSI3;

@end

/**
 * 威廉指标
 */
@protocol DZHWRModel <DZHDrawingModel>

@property (nonatomic) float WR1;

@property (nonatomic) float WR2;

@end

/**
 * 乖离率
 */
@protocol DZHBIASModel <DZHDrawingModel>

@property (nonatomic) float BIAS1;

@property (nonatomic) float BIAS2;

@property (nonatomic) float BIAS3;

@end

/**
 * 顺势指标
 */
@protocol DZHCCIModel <DZHDrawingModel>

@property (nonatomic) float CCI;

@end

/**
 * 平行线差指标
 */
@protocol DZHDMAModel <DZHDrawingModel>

@property (nonatomic) float DDD;

@property (nonatomic) float AMA;

@end

/**
 * 布林指标
 */
@protocol DZHBOLLModel <DZHDrawingModel>

@property (nonatomic) float UPP;

@property (nonatomic) float MID;

@property (nonatomic) float LOW;

@end
