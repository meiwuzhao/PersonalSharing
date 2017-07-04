//
//  DZHDrawing.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

@protocol DZHDrawingDelegate;
@protocol DZHDrawingDataSource;
@protocol DZHDrawingContainer;

/**
 * 绘制对象接口
 */
@protocol DZHDrawing <NSObject>

@property (nonatomic, assign) id<DZHDrawingContainer> container;

@property (nonatomic) BOOL isFixed;/**控制drawingFrame是相对坐标还是绝对坐标*/

@property (nonatomic) CGRect drawingFrame;/**绘图区域，默认未是相对的坐标，isFixed为YES，则为绝对坐标*/

@property (nonatomic) NSInteger drawingTag;/**绘制对象标记*/

@property (nonatomic, assign) id<DZHDrawingDataSource> drawingDataSource;

@property (nonatomic, assign) id<DZHDrawingDelegate> drawingDelegate;

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context;

@end

/**
 * 坐标轴绘制对象
 */
@protocol DZHAxisDrawing <DZHDrawing>

/**线条颜色*/
@property (nonatomic, retain) UIColor *lineColor;

/**文字颜色*/
@property (nonatomic, retain) UIColor *labelColor;

/**文字字体*/
@property (nonatomic, retain) UIFont *labelFont;

/**x轴为文字高度，y轴为文字宽度*/
@property (nonatomic, assign) int labelSpace;

@end

/**
 * 绘制对象委托接口
 */
@protocol DZHDrawingDelegate <NSObject>

@optional

- (void)prepareDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

- (void)completeDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end

/**
 * 绘制对象数据源接口
 */
@protocol DZHDrawingDataSource <NSObject>

- (NSArray *)datasForDrawing:(id<DZHDrawing>)drawing inRect:(CGRect)rect;

@end
