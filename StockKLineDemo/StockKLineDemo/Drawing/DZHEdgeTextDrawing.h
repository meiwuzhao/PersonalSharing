//
//  DZHEdgeTextDrawing.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawingBase.h"

/**
 * 文本绘制，文本具有边沿，当文字超出边沿时进行截断
 */
@interface DZHEdgeTextDrawing : DZHDrawingBase

@property (nonatomic) CGRect edge;/**文字边沿限制区域，超出边沿会截断，相对区域*/

@property (nonatomic, retain) UIFont *textFont;

@property (nonatomic, retain) UIColor *textColor;

@property (nonatomic, copy) NSString *text;

@end

