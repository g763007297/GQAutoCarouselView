//
//  ViewController.m
//  GQAutoCarouselViewDemo
//
//  Created by 高旗 on 2018/2/22.
//  Copyright © 2018年 gaoqi. All rights reserved.
//

#import "ViewController.h"

#import "GQAutoCarouselView.h"

#define GQScreen_Height [UIScreen mainScreen].bounds.size.height
#define GQScreen_Width [UIScreen mainScreen].bounds.size.width

@interface ViewController ()<GQAutoCarouselViewDataSource,GGQAutoCarouselViewDelegate>

@property (nonatomic, strong) GQAutoCarouselView *carouselView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) GQAutoCarouselViewDirection direction;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureSubviews];
    
    _direction = GQAutoCarouselViewDirectionFormTop;
    _dataSource = [[NSMutableArray alloc] initWithArray:@[@"123",@"456",@"789",@"110"]];
    
    [self.carouselView realoadData];
}

- (void)configureSubviews {
    [self.view addSubview:self.carouselView];
    
    [self.view addSubview:[self creatButtonWithTag:GQAutoCarouselViewDirectionFormTop]];
    [self.view addSubview:[self creatButtonWithTag:GQAutoCarouselViewDirectionFormLeft]];
    [self.view addSubview:[self creatButtonWithTag:GQAutoCarouselViewDirectionFormRight]];
    [self.view addSubview:[self creatButtonWithTag:GQAutoCarouselViewDirectionFormBottom]];
}

- (UIButton *)creatButtonWithTag:(GQAutoCarouselViewDirection)direction {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self configureButton:button forDirection:direction];
    button.backgroundColor = [UIColor redColor];
    [button addTarget:self action:@selector(directionAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = direction;
    return button;
}

- (void)configureButton:(UIButton *)button forDirection:(GQAutoCarouselViewDirection)direction {
    NSString *title = @"";
    CGRect frame = CGRectZero;
    CGRect carouseFrame = _carouselView.frame;
    switch (direction) {
        case GQAutoCarouselViewDirectionFormBottom: {
            title = @"从下往上";
            frame = CGRectMake((GQScreen_Width - 80)/2, CGRectGetMaxY(carouseFrame)+10, 80, 30);
            break;
        }
        case GQAutoCarouselViewDirectionFormLeft: {
            title = @"从左往右";
            frame = CGRectMake(0, CGRectGetMinY(carouseFrame)+CGRectGetHeight(carouseFrame)/2 - 15, 80, 30);
            break;
        }
        case GQAutoCarouselViewDirectionFormRight: {
            title = @"从右往左";
            frame = CGRectMake(GQScreen_Width - 80, CGRectGetMinY(carouseFrame)+CGRectGetHeight(carouseFrame)/2 - 15, 80, 30);
            break;
        }
        case GQAutoCarouselViewDirectionFormTop: {
            title = @"从上往下";
            frame = CGRectMake((GQScreen_Width - 80)/2, CGRectGetMinY(carouseFrame)-40, 80, 30);
            break;
        }
            
        default:
            break;
    }
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- action

- (void)directionAction:(UIButton *)button {
    GQAutoCarouselViewDirection direction = (GQAutoCarouselViewDirection *)button.tag;
    _direction = direction;
    [self.carouselView realoadData];
}

#pragma mark -- GQAutoCarouselViewDataSource

- (CGFloat)numberOfItemsInAutoScrollView:(GQAutoCarouselView * _Nonnull)autoCarouselView {
    return [_dataSource count];
}

- (UIView * _Nonnull)viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)reusingView {
    if (!reusingView) {
        reusingView = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
        label.backgroundColor = [UIColor yellowColor];
        label.tag = 10086;
        [reusingView addSubview:label];
    }
    ((UILabel *)[reusingView viewWithTag:10086]).text = _dataSource[index];
    return reusingView;
}

#pragma mark -- GGQAutoCarouselViewDelegate

- (void)autoScrollView:(GQAutoCarouselView * _Nonnull)autoCarouselView didSelectIndex:(NSInteger)index {
    
}

- (NSInteger)numberOfItemsInVisible:(GQAutoCarouselView * _Nonnull)autoCarouselView {
    return 3;
}

- (GQAutoCarouselViewDirection)autoScrollViewDerection:(GQAutoCarouselView *_Nonnull)autoCarouselView {
    return _direction;
}

#pragma mark -- lazy load

- (GQAutoCarouselView *)carouselView {
    if (!_carouselView) {
        _carouselView = [[GQAutoCarouselView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200)/2, 100, 200, 100) animationDuration:1.0];
        _carouselView.delegate = self;
        _carouselView.dataSource = self;
    }
    return _carouselView;
}

@end
