//
//  DZHContainer.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHDrawingContainer.h"
#import "DZHDrawingBase.h"

@interface DZHContainer : DZHDrawingBase<DZHDrawingContainer>
{
    NSMutableArray                      *_drawings;
}

@end
