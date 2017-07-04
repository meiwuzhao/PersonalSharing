//
//  DZHEdgeTextDrawing.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHEdgeTextDrawing.h"

@implementation DZHEdgeTextDrawing
{
    UIImage                         *_textImage;
}


- (void)setText:(NSString *)text
{
    if (_text != text)
    {
        _text                       = [text copy];
        
        if (_textImage)
        {
            _textImage              = nil;
        }
    }
}

- (void)drawRect:(CGRect)rect withContext:(CGContextRef)context
{
    if (_text == nil)
        return;
    
    CGContextSaveGState(context);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    
    CGRect edge                         = [self.container realRectForVirtualRect:_edge];
    CGFloat scale                       = [[UIScreen mainScreen] scale];
    
    if (!_textImage) //图片还未创建，或者文字被更改，图片给释放，需重新创建
    {
        [self initTextImageWithSize:rect.size scale:scale];
    }
    
    UIEdgeInsets inset                  = UIEdgeInsetsZero;
    if (rect.origin.x < edge.origin.x)
        inset.left                      = edge.origin.x - rect.origin.x;
    
    if (rect.origin.y < edge.origin.y)
        inset.top                       = edge.origin.y - rect.origin.y;
    
    if (CGRectGetMaxX(rect) > CGRectGetMaxX(edge))
        inset.right                     = CGRectGetMaxX(rect) - CGRectGetMaxX(edge);
    
    if (CGRectGetMaxY(rect) > CGRectGetMaxY(edge))
        inset.bottom                    = CGRectGetMaxY(rect) - CGRectGetMaxY(edge);
    
    CGRect imageRect                    = UIEdgeInsetsInsetRect(rect, inset);
    
    if (imageRect.size.width <=0 || imageRect.size.height <=0)
        return;
    
    CGImageRef subImage                 = CGImageCreateWithImageInRect (_textImage.CGImage, CGRectMake(inset.left * scale, inset.top * scale, (rect.size.width - inset.left - inset.right) * scale, (rect.size.height - inset.top - inset.bottom) * scale));
    
    UIImage *image                      = [[UIImage alloc] initWithCGImage:subImage];
    
    [image drawInRect:imageRect];
    
    CGImageRelease(subImage);
    
    CGContextRestoreGState(context);
}

- (void)initTextImageWithSize:(CGSize)size scale:(CGFloat)scale
{
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    [_textColor setFill];
    [_text drawAtPoint:CGPointZero withFont:_textFont];
    _textImage                      = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end

