//
//  GQAutoCarouselView.h
//  GQAutoCarouselViewDemo
//
//  Created by 高旗 on 2018/2/22.
//  Copyright © 2018年 gaoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GQAutoCarouselView;

typedef enum : NSUInteger {
    GQAutoCarouselViewDirectionFormTop,//从上往下
    GQAutoCarouselViewDirectionFormBottom,//从下往上
    GQAutoCarouselViewDirectionFormLeft,//从左往右
    GQAutoCarouselViewDirectionFormRight,//从右往左
} GQAutoCarouselViewDirection;

@protocol GQAutoCarouselViewDataSource <NSObject>

@required
//如果总个数小于visibleItem  则不会自动滚动
- (CGFloat)numberOfItemsInAutoScrollView:(GQAutoCarouselView * _Nonnull)autoCarouselView;

- (UIView * _Nonnull)viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)reusingView;

@end

@protocol GGQAutoCarouselViewDelegate <NSObject>

@optional
- (void)autoScrollView:(GQAutoCarouselView * _Nonnull)autoCarouselView didSelectIndex:(NSInteger)index;

- (NSInteger)numberOfItemsInVisible:(GQAutoCarouselView * _Nonnull)autoCarouselView;

- (GQAutoCarouselViewDirection)autoScrollViewDerection:(GQAutoCarouselView *_Nonnull)autoCarouselView;

@end

@interface GQAutoCarouselView : UIView

@property (nonatomic, readonly , nonnull) UIScrollView *scrollView;

@property (nonatomic, readonly) NSTimeInterval animationDuration;

@property (nonatomic, readonly) GQAutoCarouselViewDirection direction;

- (_Nullable instancetype)init NS_UNAVAILABLE;
+ (_Nullable instancetype)new NS_UNAVAILABLE;
- (nonnull instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

/**
 初始化
 
 param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 return GQAutoCarouselView
 */
+ (nonnull instancetype)initWithAnimationDuration:(NSTimeInterval)animationDuration;
- (nonnull instancetype)initWithAnimationDuration:(NSTimeInterval)animationDuration;

/**
 初始化

 param frame frame
 param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 return GQAutoCarouselView
 */
+ (nonnull instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;
- (nonnull instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

@property (nonatomic, weak, nullable) id<GQAutoCarouselViewDataSource> dataSource;

@property (nonatomic, weak, nullable) id<GGQAutoCarouselViewDelegate> delegate;

/**
 刷新数据源
 */
- (void)realoadData;

/**
 暂停定时器
 */
- (void)suspendTimer;

/**
 恢复定时器
 */
- (void)resumeTimer;

/**
 关闭定时器
 */
- (void)invalidTimer;

@end
