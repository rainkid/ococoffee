//
//  ImagePlayerView.m
//  ococoffee
//
//  Created by sam on 15/7/24.
//  Copyright (c) 2015年 sam. All rights reserved.
//

#import "Golbal.h"
#import "ImagePlayerView.h"

@interface ImagePlayerView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *advsList;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL hasNextPage;
@property (nonatomic,assign) int timerInterval;
@property (nonatomic, strong) UIPageControl *pagePoint;

@end

@implementation ImagePlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
         [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
         [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)initialize {
    [self initializeData];
    NSArray *subViews = self.subviews;
    [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self initializeScrollView];
    [self initializePageControl];
    
    [self initializeThumbView];
    [self addNSTimer];
}

#pragma mark -初始化

-(void) initializeData {
    _hasNextPage = true;
    _timerInterval = 3;
    
    _advsList = [[NSMutableArray alloc] init];
    for (int i = 1; i < 5; i++)
    {
        [_advsList addObject:[NSString stringWithFormat:@"%d.jpg",i]];
    }
}

-(void) initializeScrollView {
    //添加滑动视图
    _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    //设置代理这个必须的
    _scrollView.delegate = self;
    //设置总大小也就是里面容纳的大小
    _scrollView.contentSize = CGSizeMake(self.frame.size.width * _advsList.count, self.frame.size.height);
    [_scrollView setBackgroundColor:[UIColor whiteColor]];
    //里面的子视图跟随父视图改变大小
    [_scrollView setAutoresizesSubviews:YES];
    //设置分页形式，这个必须设置
    [_scrollView setPagingEnabled:YES];
    //隐藏横竖滑动块
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:_scrollView];
}

#pragma mark initializePageControl
-(void) initializePageControl {
    //场景UIPageControl显示控件，并修改小点颜色
    _pagePoint = [[UIPageControl alloc]init];
    _pagePoint.currentPageIndicatorTintColor = [UIColor blackColor];
    _pagePoint.pageIndicatorTintColor = [UIColor grayColor];
    _pagePoint.frame = CGRectMake(self.frame.size.width - _pagePoint.bounds.size.width-_advsList.count*10, _scrollView.frame.origin.y+135, _pagePoint.bounds.size.width, _pagePoint.bounds.size.height);
    [_pagePoint setNumberOfPages:[_advsList count]];
    [self addSubview:_pagePoint];
    
}

#pragma mark -展示广告位,初始化
-(void)initializeThumbView{
    
    for(int i = 0; i < _advsList.count; i ++){
        UIButton *thumbView = [[UIButton alloc] init];
        [thumbView addTarget:self
                      action:@selector(myDidSelectAdvAtIndex:)
            forControlEvents:UIControlEventTouchUpInside];
        thumbView.tag = i;
        thumbView.frame = CGRectMake(self.frame.size.width * i, 0, self.frame.size.width, self.frame.size.height);
        [thumbView setBackgroundImage:[UIImage imageNamed:_advsList[i]] forState:UIControlStateNormal];
        thumbView.adjustsImageWhenHighlighted = NO;
        [_scrollView addSubview:thumbView];
    }

}

#pragma mark -添加定时器
-(void)addNSTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.timerInterval target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

#pragma mark -删除定时器
-(void)removeNSTimer
{
    [ _timer invalidate];
    _timer =nil;
}


#pragma mark -定时器下一页
- (void)nextPage
{
    long num = _pagePoint.currentPage;
    if(_hasNextPage)
    {
        num++;
        if(num == _advsList.count -1){
            _hasNextPage = false;
        }
    } else {
        num--;
        if(num == 0){
            _hasNextPage = true;
        }
    }
    [self scrollToIndex:num];
}

#pragma mark -滑动的距离
- (void)scrollToIndex:(NSInteger)index
{
    CGRect frame = _scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark -滑动完成时计算滑动到第几页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    [_pagePoint setCurrentPage:page];
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

#pragma mark -点击广告
- (void)myDidSelectAdvAtIndex:(id) index
{
   
    UIButton *thumbView = (UIButton *)index;
    [self.delegate clickedBanner:thumbView.tag];
    NSLog(@"你点击了第个%ld广告",thumbView.tag);
}
@end
