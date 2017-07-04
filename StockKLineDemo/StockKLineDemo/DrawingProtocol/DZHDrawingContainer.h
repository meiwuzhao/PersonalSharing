//
//  DZHDrawingContainer.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawing.h"

/**
 * 绘制容器，用于管理绘制对象绘制位置
 */
@protocol DZHDrawingContainer <DZHDrawing>

@property (nonatomic) CGRect currentVisibleRect;/**当前正处于视图绘制的区域*/

@property (nonatomic, readonly) NSArray *subDrawings;/**该容器上的所有绘制对象*/

/**
 * 在指定位置添加一个绘制对象
 * @param drawing 绘制对象
 */
- (void)addDrawing:(id<DZHDrawing>)drawing;

/**
 * 从容器中移除对象
 * @param drawing 绘制对象
 */
- (void)removeDrawing:(id<DZHDrawing>)drawing;

/**
 * 在特定层次上添加绘制对象
 * param drawing
 *
 */
- (void)insertDrawing:(id<DZHDrawing>)drawing atIndex:(NSInteger)index;

/**
 * 将相对的绘制区域转换为当前进行绘制的实际区域，如在一个ScrollView上进行绘制时，滚动时绘制区域会变化，需进行转换
 *   绘制区域
 * @returns 图像绘制对象进行绘制的区域
 */
- (CGRect)realRectForVirtualRect:(CGRect)virtualRect;

@end
