//
//  DZHKLineViewController.m
//  StockKLineDemo
//
//  Created by Merlin on 2017/3/13.
//  Copyright © 2017年 2345. All rights reserved.
//

#import "DZHKLineViewController.h"
#import "UIColor+RGB.h"
#import "DZHKLineDataSource.h"
#import "DZHKLineContainer.h"
#import "DZHRectangleDrawing.h"
#import "DZHAxisXDrawing.h"
#import "DZHAxisYDrawing.h"
#import "DZHKLineDrawing.h"
#import "DZHFillBarDrawing.h"
#import "DZHCurveDrawing.h"
#import "DZHDrawingItemModel.h"
#import "DZHOHLCDrawing.h"

#import "DZHDataProviderContext.h"
// DataProvider
#import "DZHKLineDataProvider.h"
#import "DZHColorDataprovider.h"
#import "DZHMACDDataProvider.h"
#import "DZHKDJDataProvider.h"
#import "DZHRSIDataProvider.h"
#import "DZHWRDataProvider.h"
#import "DZHBIASDataProvider.h"
#import "DZHCCIDataProvider.h"
#import "DZHDMADataProvider.h"
#import "DZHBOLLDataProvider.h"
#import "DZHVolumeDataProvider.h"
#import "DZHEdgeTextDrawing.h"

typedef enum {
    kPRStateNormal      = 0,
    kPRStatePulling     = 1,
    kPRStateLoading     = 2,
    kPRStateHitTheEnd   = 3,
} PRState;

#define  ScreenWidth                        [[UIScreen mainScreen] bounds].size.width
#define  ScreenHeight                       [[UIScreen mainScreen] bounds].size.height

#define kLabelWidth             30.
#define kLabelHeight            20.
#define kMargin                 UIEdgeInsetsMake(5., .0, 5., 5.)
#define kPadding                UIEdgeInsetsMake(5., .0, 5., .0)

#define kContainerRect          CGRectMake(10., 25., 420., 240.)
#define kWidth                  kContainerRect.size.width - kLabelWidth - kMargin.left - kMargin.right

#define kTopHeight              160.
#define kTopContentHeight       kTopHeight - kLabelHeight - kMargin.top - kPadding.top - kPadding.bottom
#define kTopContentRect         CGRectMake(kLabelWidth, kMargin.top + kPadding.top, kWidth, kTopContentHeight)
#define kTopBorderRect          CGRectMake(kLabelWidth, kMargin.top, kWidth, kTopHeight - kLabelHeight - kMargin.top)
#define kTopAxisXRect           CGRectMake(kLabelWidth, kMargin.top, kWidth, kTopBorderRect.size.height + kLabelHeight)
#define kTopAxisYRect           CGRectMake(.0, kMargin.top + kPadding.top, kWidth + kLabelWidth,  kTopContentHeight)

#define kBottomHeight           80.
#define kBottomBorderRect       CGRectMake(kLabelWidth, kTopHeight, kWidth, kBottomHeight - kMargin.bottom)
#define kBottomAxisXRect        CGRectMake(kLabelWidth, kTopHeight, kWidth, kBottomHeight - kMargin.bottom)
#define kBottomAxisYRect        CGRectMake(.0, kTopHeight, kWidth + kLabelWidth, kBottomHeight - kMargin.bottom)

typedef enum
{
    TecIndexTagVOL,
    TecIndexTagMACD,
    TecIndexTagKDJ,
    TecIndexTagRSI,
    TecIndexTagBIAS,
    TecIndexTagCCI,
    TecIndexTagWR,
    TecIndexTagBOLL,
    TecIndexTagDMA,
}TecIndexTag;  //指标区间

@interface DZHKLineViewController ()<DZHKLineContainerDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) NSUInteger centerIndex;

@property (nonatomic, assign) CGFloat scale;

@property (nonatomic, assign) CGFloat lastOffset;

@property (nonatomic) TecIndexTag curTecIndexTag;

@end

@implementation DZHKLineViewController
{
    DZHKLineDataSource                  *_dataSource;
    DZHKLineContainer                   *kLineContainer;
    
    DZHColorDataProvider                *_colorProvider;
    DZHDataProviderContext              *_context;
    
    DZHEdgeTextDrawing                  *textDrawing;
    DZHFillBarDrawing                   *barDrawing;
    DZHOHLCDrawing                      *OHLCDrawing;
    UIScrollView                        *tecIndexControl;
    
    CAShapeLayer                        *cursorLayer;
    UILabel                             *tip;
    
    PRState                             state;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _colorProvider                      = [[DZHColorDataProvider alloc] init];
        
        _context                            = [[DZHDataProviderContext alloc] init];
        _context.startLocation              = kLabelWidth;
        
        DZHKLineDataProvider *kLineProvider = [[DZHKLineDataProvider alloc] init];
        kLineProvider.context               = _context;
        kLineProvider.colorProvider         = _colorProvider;
        
        _dataSource                         = [[DZHKLineDataSource alloc] init];
        _dataSource.context                 = _context;
        _scale                              = 1.;
        _dataSource.kLineDataProvider       = kLineProvider;
        
        //十字光标
        cursorLayer                         = [[CAShapeLayer alloc] init];
        cursorLayer.contentsScale           = [[UIScreen mainScreen] scale];
        cursorLayer.strokeColor             = [UIColor whiteColor].CGColor;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.modalPresentationCapturesStatusBarAppearance = NO;
    }
    
//    NSString *resource                  = [[NSBundle mainBundle] resourcePath];
//    NSData *unarchiveData               = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
//    NSMutableArray *datas               = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];
//    
//    NSMutableArray *klines              = [NSMutableArray array];
//    [klines addObjectsFromArray:datas];
//    [klines addObjectsFromArray:datas];
//    [klines addObjectsFromArray:datas];
//    [klines addObjectsFromArray:datas];
    
    self.view.backgroundColor           = [UIColor whiteColor];
    
    //上方提示
    tip                                 = [[UILabel alloc] initWithFrame:CGRectMake(10., 5., 400., 20.)];
    tip.font                            = [UIFont systemFontOfSize:12.];
    [self.view addSubview:tip];
    
    //整个容器
    kLineContainer                      = [[DZHKLineContainer alloc] initWithFrame:kContainerRect];
    kLineContainer.backgroundColor      = [UIColor colorFromRGB:0x0e1014];
    kLineContainer.kLineDelegate        = self;
    kLineContainer.delegate             = self;
    [self.view addSubview:kLineContainer];
    
    //十字线
    cursorLayer.frame                   = kLineContainer.frame;
    [self.view.layer addSublayer:cursorLayer];
    
    const CGFloat tecWidth              = 35.;
    const CGFloat tecHeight             = 25.;
    NSArray *arr                        = @[@"VOL",@"MACD",@"KDJ",@"RSI",@"BIAS",@"CCI",@"W&R",@"BOLL",@"DMA"];
    
    //右侧指标区间选择
    tecIndexControl                     = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(kContainerRect) + 5., 100., tecWidth, 100.)];
    tecIndexControl.backgroundColor     = [UIColor grayColor];
    tecIndexControl.contentSize         = CGSizeMake(tecWidth, tecHeight * [arr count]);
    tecIndexControl.showsVerticalScrollIndicator = NO;
    UIColor *normal                     = [UIColor orangeColor];
    UIColor *highlighted                = [UIColor whiteColor];
    UIFont *font                        = [UIFont systemFontOfSize:10.];
    for (int i = 0; i < [arr count]; i++)
    {
        UIButton *button                = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font          = font;
        [button setTitleColor:normal forState:UIControlStateNormal];
        [button setTitleColor:highlighted forState:UIControlStateHighlighted];
        [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(changeTecIndex:) forControlEvents:UIControlEventTouchUpInside];
        button.frame                    = CGRectMake(.0, tecHeight * i, tecWidth, tecHeight);
        button.tag                      = i;
        [tecIndexControl addSubview:button];
    }
    
    [self.view addSubview:tecIndexControl];
    
    //默认vol高亮
    [self hilightButtonWithTecIndexTag:TecIndexTagVOL];
    [self initDrawing];
}

- (void)initDrawing
{
    UIColor *lineColor                  = [UIColor colorFromRGB:0x1e2630];
    UIColor *labelColor                 = [UIColor colorFromRGB:0x707880];
    UIFont *labelFont                   = [UIFont systemFontOfSize:8.];
    
    //画k线外框
    DZHRectangleDrawing *rectDrawing    = [[DZHRectangleDrawing alloc] init];
    rectDrawing.drawingDelegate         = _dataSource;
    rectDrawing.lineColor               = lineColor;
    rectDrawing.drawingFrame            = kTopBorderRect;
    [kLineContainer addDrawing:rectDrawing];
    
    //画k线x轴   竖直
    DZHAxisXDrawing *axisXDrawing       = [[DZHAxisXDrawing alloc] init];
    axisXDrawing.drawingDataSource      = _dataSource;
    axisXDrawing.drawingTag             = DrawingTagsTopAxisX;
    axisXDrawing.labelColor             = labelColor;
    axisXDrawing.lineColor              = lineColor;
    axisXDrawing.labelFont              = labelFont;
    axisXDrawing.labelSpace             = 20.;
    axisXDrawing.drawingFrame           = kTopAxisXRect;
    [kLineContainer addDrawing:axisXDrawing];
    
    //画k线y轴，y轴需在k线之前绘制，因为绘制y轴的时候，为提高精度，会调整价格最大值
    DZHAxisYDrawing *axisYDrawing       = [[DZHAxisYDrawing alloc] init];
    axisYDrawing.drawingDataSource      = _dataSource;
    axisYDrawing.drawingTag             = DrawingTagsTopAxisY;
    axisYDrawing.labelFont              = labelFont;
    axisYDrawing.labelColor             = labelColor;
    axisYDrawing.lineColor              = lineColor;
    axisYDrawing.labelSpace             = kLabelWidth;
    axisYDrawing.drawingFrame           = kTopAxisYRect;
    [kLineContainer addDrawing:axisYDrawing];
    
    //画k线
    DZHKLineDrawing *klineDrawing       = [[DZHKLineDrawing alloc] init];
    klineDrawing.drawingDataSource      = _dataSource;
    klineDrawing.drawingTag             = DrawingTagsTopMain;
    klineDrawing.drawingFrame           = kTopContentRect;
    [kLineContainer addDrawing:klineDrawing];
    
    //k线移动平均线
    DZHCurveDrawing *maDrawing        = [[DZHCurveDrawing alloc] init];
    maDrawing.drawingDataSource         = _dataSource;
    maDrawing.drawingTag                = DrawingTagsTopExtend;
    maDrawing.drawingFrame              = kTopContentRect;
    [kLineContainer addDrawing:maDrawing];
    
    //边缘加载更多
    textDrawing                         = [[DZHEdgeTextDrawing alloc] init];
    textDrawing.isFixed                 = YES;
    textDrawing.edge                    = CGRectMake(kLabelWidth + 1, .0, 1000., 1000.);
    textDrawing.text                    = @"加载数据";
    UIFont *font = [UIFont systemFontOfSize:8.];
    textDrawing.textFont                = font;
    textDrawing.textColor               = [UIColor colorFromRGB:0x707880];
    CGSize size                         = [textDrawing.text sizeWithFont:font];
    textDrawing.drawingFrame            = CGRectMake(kLabelWidth - size.width, 85., size.width, size.height);
    [kLineContainer addDrawing:textDrawing];
    
    //画成交量外框
    DZHRectangleDrawing *volRectDrawing = [[DZHRectangleDrawing alloc] init];
    volRectDrawing.lineColor            = lineColor;
    volRectDrawing.drawingFrame         = kBottomBorderRect;
    [kLineContainer addDrawing:volRectDrawing];
    
    //画成交量x轴的直线
    DZHAxisXDrawing *volumeAxisXDrawing = [[DZHAxisXDrawing alloc] init];
    volumeAxisXDrawing.drawingDataSource    = _dataSource;
    volumeAxisXDrawing.drawingTag       = DrawingTagsBottomAxisX;
    volumeAxisXDrawing.lineColor        = lineColor;
    volumeAxisXDrawing.drawingFrame     = kBottomAxisXRect;
    [kLineContainer addDrawing:volumeAxisXDrawing];
    
    //画成交量y轴的直线
    DZHAxisYDrawing *volumeAxisYDrawing = [[DZHAxisYDrawing alloc] init];
    volumeAxisYDrawing.drawingDataSource    = _dataSource;
    volumeAxisYDrawing.drawingTag       = DrawingTagsBottomAxisY;
    volumeAxisYDrawing.labelFont        = labelFont;
    volumeAxisYDrawing.labelColor       = labelColor;
    volumeAxisYDrawing.lineColor        = lineColor;
    volumeAxisYDrawing.labelSpace       = kLabelWidth;
    volumeAxisYDrawing.drawingFrame     = kBottomAxisYRect;
    [kLineContainer addDrawing:volumeAxisYDrawing];
    
    //画成交量柱
    barDrawing                          = [[DZHFillBarDrawing alloc] init];
    barDrawing.drawingDataSource        = _dataSource;
    barDrawing.drawingTag               = DrawingTagsBottomMain;
    barDrawing.drawingFrame             = kBottomBorderRect;
    [kLineContainer addDrawing:barDrawing];
    
    OHLCDrawing                         = [[DZHOHLCDrawing alloc] init];
    OHLCDrawing.drawingDataSource       = _dataSource;
    OHLCDrawing.drawingTag              = DrawingTagsBottomMain;
    OHLCDrawing.drawingFrame            = kBottomBorderRect;
    
    //成交量移动平均线
    DZHCurveDrawing *volMADrawing     = [[DZHCurveDrawing alloc] init];
    volMADrawing.drawingDataSource      = _dataSource;
    volMADrawing.drawingTag             = DrawingTagsBottomExtend;
    volMADrawing.drawingFrame           = kBottomBorderRect;
    [kLineContainer addDrawing:volMADrawing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setTecIndexDataProviderWithTag:TecIndexTagVOL];
    
    NSString *resource          = [[NSBundle mainBundle] resourcePath];
    NSData *unarchiveData       = [NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@/klines.data",resource]];
    NSMutableArray *datas       = [NSKeyedUnarchiver unarchiveObjectWithData:unarchiveData];
    
    NSMutableArray *klines      = [NSMutableArray array];
    [klines addObjectsFromArray:datas];

    _dataSource.klines              = klines;
    [self changeScrollContainerContentSize:CGSizeMake([self _getContainerWidth], kLineContainer.frame.size.height)];
}

- (CGFloat)_getContainerWidth
{
    return [_context totalWidth] + kLabelWidth + kMargin.left + kMargin.right;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)changeScrollContainerContentSize:(CGSize)size
{
    CGFloat oldContentWidth     = kLineContainer.contentSize.width;
    CGRect frame                = kLineContainer.frame;
    CGFloat newContentWidth     = size.width;
    
    if (newContentWidth < frame.size.width)
    {
        kLineContainer.contentSize  = CGSizeMake(frame.size.width + 1., frame.size.height);
    }
    else
    {
        kLineContainer.contentSize  = CGSizeMake(newContentWidth, frame.size.height);
        [kLineContainer scrollRectToVisible:CGRectMake(newContentWidth - oldContentWidth - frame.size.width, .0, frame.size.width, frame.size.height) animated:NO];
    }
}

- (void)changeTecIndex:(UIButton *)sender
{
    self.curTecIndexTag         = sender.tag;
}

- (void)setCurTecIndexTag:(TecIndexTag)curTecIndexTag
{
    if (_curTecIndexTag != curTecIndexTag)
    {
        _curTecIndexTag                     = curTecIndexTag;
        
        [self hilightButtonWithTecIndexTag:curTecIndexTag];
        [self setTecIndexDataProviderWithTag:curTecIndexTag];
    }
}

- (void)hilightButtonWithTecIndexTag:(TecIndexTag)curTecIndexTag
{
    UIColor *normal                     = [UIColor orangeColor];
    UIColor *highlighted                = [UIColor whiteColor];
    for (UIView *v in tecIndexControl.subviews)
    {
        if ([v isKindOfClass:[UIButton class]])
        {
            UIButton *btn               = (UIButton *)v;
            if (btn.tag != curTecIndexTag)
                [btn setTitleColor:normal forState:UIControlStateNormal];
            else
                [btn setTitleColor:highlighted forState:UIControlStateNormal];
        }
    }
}

- (void)setTecIndexDataProviderWithTag:(TecIndexTag)tag
{
    id<DZHDataProviderProtocol> indexDataProvider   = nil;
    switch (tag)
    {
        case TecIndexTagVOL:
            indexDataProvider   = [[DZHVolumeDataProvider alloc] init];
            break;
        case TecIndexTagMACD:
            indexDataProvider   = [[DZHMACDDataProvider alloc] init];
            break;
        case TecIndexTagKDJ:
            indexDataProvider   = [[DZHKDJDataProvider alloc] init];
            break;
        case TecIndexTagRSI:
            indexDataProvider   = [[DZHRSIDataProvider alloc] init];
            break;
        case TecIndexTagBIAS:
            indexDataProvider   = [[DZHBIASDataProvider alloc] init];
            break;
        case TecIndexTagCCI:
            indexDataProvider   = [[DZHCCIDataProvider alloc] init];
            break;
        case TecIndexTagWR:
            indexDataProvider   = [[DZHWRDataProvider alloc] init];
            break;
        case TecIndexTagBOLL:
            indexDataProvider   = [[DZHBOLLDataProvider alloc] init];
            break;
        case TecIndexTagDMA:
            indexDataProvider   = [[DZHDMADataProvider alloc] init];
            break;
        default:
            break;
    }
    
    NSInteger idx               = [[kLineContainer subDrawings] count] - 2;
    if (tag == TecIndexTagBOLL)
    {
        [kLineContainer removeDrawing:barDrawing];
        [kLineContainer insertDrawing:OHLCDrawing atIndex:idx];
    }
    else
    {
        id<DZHDrawing> drawing      = [[kLineContainer subDrawings] objectAtIndex:idx];
        
        if (drawing == OHLCDrawing)
        {
            [kLineContainer removeDrawing:OHLCDrawing];
            [kLineContainer insertDrawing:barDrawing atIndex:idx];
        }
    }
    
    indexDataProvider.colorProvider = _colorProvider;
    indexDataProvider.context       = _context;
    _dataSource.indexDataProvider   = indexDataProvider;
    [_dataSource reloadTecIndexData];
    [kLineContainer setNeedsDisplay];
}

#pragma mark -  DZHKLineContainerDelegat

- (CGFloat)scaledOfkLineContainer:(DZHKLineContainer *)container
{
    self.centerIndex            = (_context.fromIndex + _context.toIndex) * .5;
    return _scale;
}

- (void)kLineContainer:(DZHKLineContainer *)container scaled:(CGFloat)scale
{
    CGFloat maxScale            = _context.maxScale;
    CGFloat minScale            = _context.minScale;
    CGFloat finalScale          = scale > 1. ? 1.5 * scale : .7 * scale; //乘一个系数，增加放大时的平滑度
    
    if (finalScale >= maxScale && _context.scale == maxScale)//超出最大缩放倍数，不做处理
        return;
    if (finalScale <= minScale && _context.scale == minScale)//超出最小缩放倍数，不做处理
        return;
    
    CGRect frame                = container.frame;
    _context.scale              = MAX(MIN(finalScale,maxScale),minScale);
    _scale                      = MAX(MIN(scale,maxScale),minScale);
    CGFloat newPosition         = [_context locationForIndex:self.centerIndex];
    container.contentSize       = CGSizeMake([self _getContainerWidth], frame.size.height);
    
    if (container.contentOffset.x == 0)//offset为0时，手动刷新
    {
        [container setNeedsDisplay];
    }
    else
    {
        [container scrollRectToVisible:CGRectMake(newPosition - frame.size.width * .5, .0, frame.size.width, frame.size.height) animated:NO];
    }
}

- (void)kLineContainer:(DZHKLineContainer *)container longPressLocation:(CGPoint)point state:(UIGestureRecognizerState)state
{
    if (state == UIGestureRecognizerStateBegan || state == UIGestureRecognizerStateChanged)
    {
        NSUInteger index            = [_context nearIndexForLocation:point.x];
        
        DZHDrawingItemModel *model  = [_dataSource.klines objectAtIndex:index];
        
        CGFloat minX                = CGRectGetMinX(kTopContentRect);
        CGFloat maxX                = CGRectGetMaxX(kTopContentRect);
        CGFloat minY                = CGRectGetMinY(kTopContentRect);
        CGFloat maxY                = CGRectGetMaxY(kTopContentRect);
        
        CGFloat x                   = [_context centerLocationForIndex:index] - container.contentOffset.x;
        x                           = MIN(maxX, MAX(minX, x));
        CGFloat y                   = MIN(maxY, MAX(minY, point.y));
        
        CGMutablePathRef path       = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, x, CGRectGetMinY(kTopBorderRect));
        CGPathAddLineToPoint(path, NULL, x, CGRectGetMaxY(kTopBorderRect));
        
        CGPathMoveToPoint(path, NULL, x, CGRectGetMinY(kBottomBorderRect));
        CGPathAddLineToPoint(path, NULL, x, CGRectGetMaxY(kBottomBorderRect));
        
        CGPathMoveToPoint(path, NULL, minX, y);
        CGPathAddLineToPoint(path, NULL, maxX, y);
        
        cursorLayer.path            = path;
        CGPathRelease(path);
        
        NSString *str                   = [NSString stringWithFormat:@"开:%.2f  收:%.2f  高:%.2f  低:%.2f 日期:%d 索引:%lu",model.open,model.close,model.high, model.low, model.date, (unsigned long)index];
        tip.text                        = str;
    }
    else
    {
        cursorLayer.path            = NULL;
        tip.text                    = nil;
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < - textDrawing.drawingFrame.size.width)
        state                               = kPRStatePulling;
    else
        state                               = kPRStateNormal;
    
    [scrollView setNeedsDisplay];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (state == kPRStateLoading || state == kPRStateNormal)
        return;
    
    CGPoint offset                          = scrollView.contentOffset;
    state                                   = kPRStateLoading;
    
    //更改contentInset会导致调用scrollViewDidScroll，并使contentOffset变为-contentInset.left，所以紧接后面将contentOffset设置为正确值
    scrollView.contentInset                 = UIEdgeInsetsMake(0 , 5. + textDrawing.drawingFrame.size.width, 0, 0);
    
    scrollView.contentOffset                = offset;
    
    textDrawing.text                        = @"加载中";
    [scrollView setNeedsDisplay];
    
    [self performSelector:@selector(didFinishedLoading) withObject:nil afterDelay:1.];
}

- (void)didFinishedLoading
{
    state                                   = kPRStateNormal;
    textDrawing.text                        = nil;
    [UIView animateWithDuration:.5 animations:^{
        kLineContainer.contentInset         = UIEdgeInsetsZero;
    } completion:^(BOOL bl){
        textDrawing.text                    = @"加载数据";
    }];
}

@end
