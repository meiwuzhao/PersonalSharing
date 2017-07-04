//
//  DZHAxisDrawingBase.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawingBase.h"

@interface DZHAxisDrawingBase : DZHDrawingBase<DZHAxisDrawing>

- (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font alignment:(NSTextAlignment)alignment;

@end
