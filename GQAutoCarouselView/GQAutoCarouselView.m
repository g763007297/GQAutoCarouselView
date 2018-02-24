//
//  GQAutoCarouselView.m
//  GQAutoCarouselViewDemo
//
//  Created by 高旗 on 2018/2/22.
//  Copyright © 2018年 gaoqi. All rights reserved.
//

#import "GQAutoCarouselView.h"
#import "GQTimer.h"

@interface GQAutoCarouselView() <UIScrollViewDelegate> {
@private
    NSInteger _currentPageIndex;
    NSInteger _totalPageCount;
    NSInteger _visibleNumber;
    GQAutoCarouselViewDirection _direction;
}

@property (nonatomic, assign) CGFloat itemWidth;

@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) GQTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;

@end

@implementation GQAutoCarouselView

+ (nonnull instancetype)initWithAnimationDuration:(NSTimeInterval)animationDuration {
    GQAutoCarouselView *autoCarouselView = [self initWithFrame:CGRectZero animationDuration:animationDuration];
    return autoCarouselView;
}

- (nonnull instancetype)initWithAnimationDuration:(NSTimeInterval)animationDuration {
    self = [self initWithFrame:CGRectZero animationDuration:animationDuration];
    return self;
}

+ (nonnull instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration {
    GQAutoCarouselView *autoCarouselView = [[self alloc] initWithFrame:frame animationDuration:animationDuration];
    return autoCarouselView;
}

- (nonnull instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration {
    self = [super initWithFrame:frame];
    if (self) {
        self.animationDuration = animationDuration;
        [self configureSubViews];
    }
    
    return self;
}

- (void)dealloc {
    [self invalidTimer];
    _animationTimer = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configContentViews];
}

#pragma mark -- private method

- (void)configureInformation {
    if (self.delegate && [self.delegate respondsToSelector:@selector(autoScrollViewDerection:)]) {
        _direction = [self.delegate autoScrollViewDerection:self];
    } else
        _direction = GQAutoCarouselViewDirectionFormTop;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfItemsInVisible:)]) {
        _visibleNumber =  [self.delegate numberOfItemsInVisible:self];
    } else
        _visibleNumber = 1;
    
    _scrollView.pagingEnabled = _visibleNumber == 1;
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfItemsInAutoScrollView:)]) {
        _totalPageCount = [self.dataSource numberOfItemsInAutoScrollView:self];
    } else
        _totalPageCount = 0;
}

- (void)configureItemWidth {
    float height = 0;
    float visibleNumber = _visibleNumber==0 ? 1 : _visibleNumber;
    switch (self.direction) {
        case GQAutoCarouselViewDirectionFormTop:
        case GQAutoCarouselViewDirectionFormBottom:
        {
            height = self.frame.size.height;
            break;
        }
            
        case GQAutoCarouselViewDirectionFormLeft:
        case GQAutoCarouselViewDirectionFormRight:
        {
            height = self.frame.size.width;
            break;
        }
        default:
            break;
    }
    
    _itemWidth = height / visibleNumber;
}

- (void)configureSubViews {
    _currentPageIndex = 0;
    [self addSubview:self.scrollView];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scrollView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    
    NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scrollView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    
    NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scrollView.superview attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    
    NSLayoutConstraint *right = [NSLayoutConstraint constraintWithItem:self.scrollView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scrollView.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    
    [self addConstraint:left];
    [self addConstraint:right];
    [self addConstraint:top];
    [self addConstraint:bottom];
}

//配置滚动条目
- (BOOL)configContentViews
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (_totalPageCount == 0) {
        return NO;
    }
    
    if (_currentPageIndex >= _totalPageCount) {
        _currentPageIndex = _totalPageCount - 1;
    }
    
    [self setScrollViewContentDataSource];
    
    CGPoint point = [self configureCGPoint];
    NSInteger index = _totalPageCount <= _visibleNumber ? _totalPageCount :_visibleNumber + 1;
    
    for (int i = 0; i <= index; i++) {
        UIView *contentView = self.contentViews[i];
        [self.scrollView addSubview:contentView];
        [UIView animateWithDuration:0.2 animations:^{
            
            [contentView removeConstraints:contentView.constraints];
            contentView.translatesAutoresizingMaskIntoConstraints = NO;
            NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:contentView.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:point.y * i];
            
            NSLayoutConstraint *left = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:contentView.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:point.x * i];
            
            NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem: (point.x == 0 ? contentView.superview : nil ) attribute:NSLayoutAttributeWidth multiplier:1.0 constant: (point.x == 0 ?0 : point.x) ];
            
            NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem: (point.y == 0 ? contentView.superview : nil ) attribute:NSLayoutAttributeHeight multiplier:1.0 constant: (point.y == 0 ?0 : point.y) ];
            
            [self.scrollView addConstraint:top];
            [self.scrollView addConstraint:left];
            [self.scrollView addConstraint:width];
            [self.scrollView addConstraint:height];
            
            [self.scrollView layoutIfNeeded];
        }];
    }
    
    _scrollView.contentSize = CGSizeMake((_visibleNumber + 2) * [self configureCGPoint].x, (_visibleNumber + 2) * [self configureCGPoint].y);
    
    [_scrollView setContentOffset:point];
    
    if (_totalPageCount < _visibleNumber) {
        return NO;
    }
    
    return YES;
}

//配置下一页
- (void)setupNextPage {
    CGPoint newOffset = self.scrollView.contentOffset;
    
    switch (self.direction) {
        case GQAutoCarouselViewDirectionFormBottom:
        case GQAutoCarouselViewDirectionFormRight:
        {
            newOffset = CGPointMake(self.scrollView.contentOffset.x == 0 ? 0 : self.scrollView.contentOffset.x + self.itemWidth, self.scrollView.contentOffset.y == 0 ? 0 : self.scrollView.contentOffset.y + self.itemWidth);
            break;
        }
        case GQAutoCarouselViewDirectionFormLeft:
        case GQAutoCarouselViewDirectionFormTop:
        {
            newOffset = CGPointMake(self.scrollView.contentOffset.x == 0 ? 0 : self.scrollView.contentOffset.x - self.itemWidth, self.scrollView.contentOffset.y == 0 ? 0 : self.scrollView.contentOffset.y - self.itemWidth);
        }
        default:
            break;
    }
    _currentPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + 1];
    
    [UIView animateWithDuration:0.25
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut animations:^{
                            [self.scrollView setContentOffset:newOffset];
                        } completion:^(BOOL finished) {
                            [self setScrollViewContentDataSource];
                            [self.scrollView setContentOffset:self.configureCGPoint];
                        }];
}

//根据source配置contenView
- (void)setScrollViewContentDataSource
{
    NSMutableArray *array = [NSMutableArray new];
    
    switch (self.direction) {
        case GQAutoCarouselViewDirectionFormBottom:
        case GQAutoCarouselViewDirectionFormRight:
        {
            
            UIView *reusingView = [self configureViewWithindex:_currentPageIndex
                                                   reusingView:[self reusingViewWithIndex:0]];
            if (reusingView) {
                [array addObject:reusingView];
                NSInteger index = _totalPageCount <= _visibleNumber ? _totalPageCount : _visibleNumber + 1;
                
                for (NSInteger i = 1; i <= index; i++) {
                    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + i - 1];
                    
                    [array addObject:[self configureViewWithindex:rearPageIndex
                                                      reusingView:[self reusingViewWithIndex:i]]];
                }
            }
            
            break;
        }
        case GQAutoCarouselViewDirectionFormLeft:
        case GQAutoCarouselViewDirectionFormTop:
        {
            
            NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex - 2];
            UIView *reusingView = [self configureViewWithindex:previousPageIndex
                                                   reusingView:[self reusingViewWithIndex:0]];
            if (reusingView) {
                [array addObject:reusingView];
                NSInteger index = _totalPageCount <= _visibleNumber ? _totalPageCount + 1 :_visibleNumber + 1;
                
                for (NSInteger i = index - 1; i >= 0; i--) {
                    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:_currentPageIndex + index - i - 1];
                    
                    [array addObject:[self configureViewWithindex:rearPageIndex
                                                      reusingView:[self reusingViewWithIndex:i]]];
                }
            }
            
            break;
        }
        default:
            break;
    }
    if (self.contentViews == nil) {
        self.contentViews = [[NSMutableArray alloc] initWithArray:array];
    }
}

//获取指定位置的视图
- (UIView *)reusingViewWithIndex:(NSInteger)index {
    if (self.contentViews.count > index) {
        return self.contentViews[index];
    }
    
    return nil;
}

//获取可用的pageIndex
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex <= -1) {
        return _totalPageCount + currentPageIndex;
    } else if (currentPageIndex >= _totalPageCount) {
        if (_totalPageCount < _visibleNumber) {
            return currentPageIndex % _totalPageCount;
        }
        return currentPageIndex - _totalPageCount;
    } else {
        return currentPageIndex;
    }
}

//配置指定index的视图
- (UIView *)configureViewWithindex:(NSInteger)index reusingView:(nullable UIView *)reusingView {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(viewForItemAtIndex:reusingView:)]) {
        return [self.dataSource viewForItemAtIndex:index reusingView:reusingView];
    }
    return nil;
}

#pragma mark -- public method

- (void)realoadData {
    [self invalidTimer];
    
    [self configureInformation];
    
    [self configureItemWidth];
    
    [self configContentViews];
    
    [self resumeTimer];
}

/**暂停定时器*/
- (void)suspendTimer {
    [self.animationTimer suspend];
}

/**恢复定时器*/
- (void)resumeTimer {
    [self animationTimerValid] ? [self.animationTimer resumeTimerAfterTimeInterval:self.animationDuration] : [self.scrollView setContentOffset:self.configureCGPoint];
}

/**关闭定时器*/
- (void)invalidTimer {
    [self.animationTimer invalid];
}

#pragma mark -- lazy load

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollView.decelerationRate = UIScrollViewDecelerationRateFast;
        _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
        _scrollView.contentMode = UIViewContentModeCenter;
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setShowsVerticalScrollIndicator:NO];
        
        _scrollView.delegate = self;
        
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.bounces = NO;
    }
    
    return _scrollView;
}

- (GQTimer *)animationTimer {
    if (!_animationTimer) {
        __weak __typeof(self) weakSelf = self;
        _animationTimer = [GQTimer timerWithTimerStep:self.animationDuration repeats:YES withBlock:^(GQTimer *timer) {
            __strong __typeof(self) strongSelf = weakSelf;
            [strongSelf setupNextPage];
            NSLog(@"%.f",timer.timeInterval);
        }];
        [_animationTimer resume];
    }
    
    return _animationTimer;
}

- (CGPoint)configureCGPoint {
    CGFloat x = 0;
    CGFloat y = 0;
    switch (self.direction) {
        case GQAutoCarouselViewDirectionFormLeft:
        case GQAutoCarouselViewDirectionFormRight:
        {
            x = self.itemWidth;
            y = 0;
            break;
        }
        case GQAutoCarouselViewDirectionFormTop:
        case GQAutoCarouselViewDirectionFormBottom: {
            y = self.itemWidth;
            x = 0;
            break;
        }
        default:
            break;
    }
    
    return CGPointMake(x, y);
}

- (BOOL)animationTimerValid {
    if (_totalPageCount == 0 || _totalPageCount <= _visibleNumber || self.animationDuration < 0) {
        return NO;
    }
    
    return YES;
}

@end
