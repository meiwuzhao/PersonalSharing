//
//  DZHScrollContainer.h
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHContainer.h"

@interface DZHScrollContainer : UIScrollView<DZHDrawingContainer>
{
    DZHContainer                        *_container;
}

@end
