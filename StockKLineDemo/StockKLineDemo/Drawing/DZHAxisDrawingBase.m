//
//  DZHAxisDrawingBase.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHAxisDrawingBase.h"

#import "DZHAxisDrawingBase.h"

@implementation DZHAxisDrawingBase

@synthesize lineColor           = _lineColor;
@synthesize labelColor          = _labelColor;
@synthesize labelFont           = _labelFont;
@synthesize labelSpace          = _labelSpace;


- (void)drawStrInRect:(NSString *)str rect:(CGRect)rect font:(UIFont *)font alignment:(NSTextAlignment)alignment
{
    [str drawInRect:rect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:alignment];
}

@end
