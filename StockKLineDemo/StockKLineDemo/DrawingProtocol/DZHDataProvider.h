//
//  DZHDataProvider.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

@protocol DZHDataProviderContextProtocol <NSObject>

@property (nonatomic) NSInteger fromIndex;
@property (nonatomic) NSInteger toIndex;

@property (nonatomic) CGFloat originItemWidth;
@property (nonatomic) CGFloat itemWidth;
@property (nonatomic) CGFloat itemPadding;
@property (nonatomic) CGFloat startLocation;

@property (nonatomic, retain) NSArray *datas;
@property (nonatomic) NSInteger itemCount;

@property (nonatomic) CGFloat scale;
@property (nonatomic) CGFloat maxScale;
@property (nonatomic) CGFloat minScale;

- (CGFloat)totalWidth;

- (CGFloat)locationForIndex:(NSUInteger)index;

- (CGFloat)centerLocationForIndex:(NSUInteger)index;

- (NSUInteger)nearIndexForLocation:(CGFloat)position;

- (void)calculateFromAndToIndexWithRect:(CGRect)rect;

@end

@protocol DZHColorDataProviderProtocol <NSObject>

- (UIColor *)colorForKLineType:(KLineType)kType;

- (UIColor *)colorForMACycle:(KLineCycle)cycle;


- (UIColor *)colorForVolumeType:(VolumeType)volumeType;

- (UIColor *)colorForVolumeMACycle:(KLineCycle)cycle;


- (UIColor *)colorForMACDLineType:(MACDLineType)type;

- (UIColor *)colorForMACDType:(MACDType)type;


- (UIColor *)colorForKDJType:(KDJLineType)KDJType;


- (UIColor *)colorForRSIType:(RSILineType)KDJType;


- (UIColor *)colorForWRType:(WRLineType)WRType;


- (UIColor *)colorForBIASType:(BIASLineType)BIASType;


- (UIColor *)colorForCCILine;


- (UIColor *)colorForDMAType:(DMALineType)DMAType;


- (UIColor *)colorForBOLLType:(BOLLLineType)BOLLType;

@end

@protocol DZHDataProviderProtocol <NSObject>

@property (nonatomic, assign) id<DZHDataProviderContextProtocol> context;
@property (nonatomic, assign) id<DZHColorDataProviderProtocol> colorProvider;

/**
 * 获取指标绘制开始位置，如果索引小于指标周期，返回该指标绘制的第一个点;否则返回当前索引
 */
- (NSInteger)beginOfIndex:(NSInteger)idx indexCycle:(int)cycle;

/**
 * 初始化或者更改数据的时候，计算、设置关键值，如MA数据源，计算各个周期MA的值
 */
- (void)setupPropertyWhenTravelLastData:(id)lastData currentData:(id)curData index:(NSInteger)index;

/**
 * 计算最大值最小值
 */
- (void)setupMaxAndMinWhenTravelLastData:(id)lastData currentData:(id)data index:(NSInteger)index;

@optional

/**
 * 横坐标数据
 */
- (NSArray *)axisXDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 纵坐标数据
 */
- (NSArray *)axisYDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 绘制项数据
 */
- (NSArray *)itemDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

/**
 * 额外数据，如k线、量线的平均线。
 */
- (NSArray *)extendDatasWithContext:(id<DZHDataProviderContextProtocol>)context top:(CGFloat)top bottom:(CGFloat)bottom;

@end
