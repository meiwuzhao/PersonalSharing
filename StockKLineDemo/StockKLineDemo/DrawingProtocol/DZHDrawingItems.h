//
//  DZHDrawingItems.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

/**
 * 绘制项接口，一个完整的图像，是由一串绘制项数据经过绘制加工而生成
 */
@protocol DZHDrawingItemProtocol <NSObject>

@end

/**
 * k线绘制项
 */
@protocol DZHKLineItem <DZHDrawingItemProtocol>

@property (nonatomic, assign) CGRect solidRect;/**开盘、收盘*/

@property (nonatomic, assign) CGRect stickRect;/**最高、最低*/

@property (nonatomic, retain) UIColor *stickColor;/**蜡烛图颜色*/

@end

/**
 * 柱状图绘制项
 */
@protocol DZHBarItem <DZHDrawingItemProtocol>

@property (nonatomic, assign) CGRect barRect;/**柱*/

@property (nonatomic, retain) UIColor *barFillColor;/**柱填充颜色*/

@end

/**
 * 美国线绘制项，3条线组成
 */
@protocol DZHOHLCItem <DZHDrawingItemProtocol>

@property (nonatomic, assign) CGPoint *linePoints;

@property (nonatomic, retain) UIColor *lineColor;

@end

/**
 * 坐标轴绘制项
 */
@protocol DZHAxisLineItem <NSObject>

/**绘制x轴表示x坐标，绘制y轴表示y轴坐标*/
@property (nonatomic) CGPoint location;

/**刻度上显示的文本字符串*/
@property (nonatomic, copy) NSString *labelText;

/**是否不绘制直线，只显示文本*/
@property (nonatomic) BOOL notDrawLine;

/**虚线设置，如果不为nil则绘制虚线，否则绘制实线*/
@property (nonatomic, retain) NSArray *dashLengths;

@end

/**
 * 曲线绘制项
 */
@protocol DZHLineItem <NSObject>

/**曲线绘制颜色*/
@property (nonatomic, retain) UIColor *color;

/**曲线点集合*/
@property (nonatomic) CGPoint *points;

/**曲线点个数*/
@property (nonatomic) NSInteger count;

/**各点是否用Bezier曲线连接，默认为Bezier曲线*/
@property (nonatomic) BOOL isBezier;

- (void)setPoints:(CGPoint *)points withCount:(NSInteger)count;

@end

@protocol DZHGradientItem <NSObject>

/**曲线点集合*/
@property (nonatomic) CGPoint *points;

/**曲线点个数*/
@property (nonatomic) NSInteger count;

/**各点是否用Bezier曲线连接，默认为Bezier曲线*/
@property (nonatomic) BOOL isBezier;

/**渐变颜色,[CGColorRef]*/
@property (nonatomic, retain) NSArray *colors;

- (void)setPoints:(CGPoint *)points withCount:(NSInteger)count;

@end
