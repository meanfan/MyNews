//
//  AdScrollView.m
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/17.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "AdScrollView.h"
#import "UIImageView+WebCache.h"
@interface AdScrollView()<UIScrollViewDelegate>{
    int _centerIndex;
    NSArray *_imageNameArray;
    NSTimeInterval _timeInterval;
}
@property (nonatomic ,strong) UIScrollView *adScrollView;
@property (nonatomic ,strong) UIImageView *leftImgView;
@property (nonatomic ,strong) UIImageView *centerImgView;
@property (nonatomic ,strong) UIImageView *rightImgView;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,strong) UIPageControl *pageControl;
@property (nonatomic ,copy) void (^advertClickBlock) (int selectIndex);
@end

@implementation AdScrollView

+ (instancetype)advertScrollViewFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray timeInterval:(NSTimeInterval)timeInterval advertSelectBlock:(void(^)(int selectIndex))advertSelectBlock{
    return [[self alloc]initWithFrame:frame imagesArray:imagesArray timeInterval:timeInterval advertSelectBlock:advertSelectBlock];
}

-(instancetype)initWithFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray timeInterval:(NSTimeInterval)timeInterval advertSelectBlock:(void(^)(int selectIndex))advertSelectBlock{
    self = [super initWithFrame:frame];
    if (self) {
        _imageNameArray = [imagesArray copy];
        self.advertClickBlock = advertSelectBlock;
        _timeInterval = timeInterval;
        if (_timeInterval <= 0) {
            _timeInterval = 5;
        }
        [self setSubviews];
        [self startTimer];
    }
    return self;
}

#pragma mark -----lazy
- (UIScrollView *)adScrollView{
    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.backgroundColor = [UIColor whiteColor];
        _adScrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
        _adScrollView.contentOffset = CGPointMake(CGRectGetWidth(self.bounds), 0);
        _adScrollView.delegate = self;
        _adScrollView.bounces = NO;
        UITapGestureRecognizer *panGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(jumpToAdvertDetail)];
        [_adScrollView addGestureRecognizer:panGesture];
        [self addSubview:_adScrollView];
    }
    return _adScrollView;
}

- (UIImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _leftImgView.clipsToBounds = YES;
        _leftImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.adScrollView addSubview:_leftImgView];
    }
    return _leftImgView;
}

- (UIImageView *)centerImgView{
    if (!_centerImgView) {
        _centerImgView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _centerImgView.clipsToBounds = YES;
        _centerImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.adScrollView addSubview:_centerImgView];
    }
    return _centerImgView;
}

- (UIImageView *)rightImgView{
    if (!_rightImgView) {
        _rightImgView = [[UIImageView alloc]initWithFrame:CGRectMake(2 * CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        _rightImgView.clipsToBounds = YES;
        _rightImgView.contentMode = UIViewContentModeScaleAspectFill;
        [self.adScrollView addSubview:_rightImgView];
    }
    return _rightImgView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]init];
        CGSize size = [_pageControl sizeForNumberOfPages:_imageNameArray.count];
        _pageControl.frame = CGRectMake((CGRectGetWidth(self.bounds) - size.width) / 2, CGRectGetHeight(self.bounds) - size.height, size.width, size.height);
        _pageControl.center = CGPointMake(self.adScrollView.center.x, _pageControl.center.y);
        _pageControl.numberOfPages = _imageNameArray.count;
        _pageControl.hidesForSinglePage = YES;
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
        [self insertSubview:_pageControl aboveSubview:self.adScrollView];
    }
    return _pageControl;
}

#pragma mark -----operation methods
- (void)setSubviews{
    if (_centerIndex < 0) {
        _centerIndex = (int)_imageNameArray.count - 1;
    }
    if (_centerIndex >= _imageNameArray.count) {
        _centerIndex = 0;
    }
    int leftIndex = _centerIndex - 1;
    if (leftIndex < 0){
        leftIndex = (int)_imageNameArray.count - 1;
    }
    int rightIndex = _centerIndex + 1;
    if (rightIndex >= _imageNameArray.count) {
        rightIndex = 0;
    }
    NSLog(@"leftIndex:%d;_centerIndex:%d;rightIndex:%d",leftIndex,_centerIndex,rightIndex);
    if ((leftIndex >= _imageNameArray.count || _centerIndex >= _imageNameArray.count || rightIndex >= _imageNameArray.count)) {
        NSLog(@"数组越界");
        return;
    }
    
    NSString *leftImgName = [_imageNameArray objectAtIndex:leftIndex];
    NSString *centerImgName = [_imageNameArray objectAtIndex:_centerIndex];
    NSString *rightImgName = [_imageNameArray objectAtIndex:rightIndex];
    

    //url images
     [self.leftImgView sd_setImageWithURL:[NSURL URLWithString:leftImgName] placeholderImage:[UIImage imageNamed:leftImgName]];
     [self.centerImgView sd_setImageWithURL:[NSURL URLWithString:centerImgName] placeholderImage:[UIImage imageNamed:centerImgName]];
     [self.rightImgView sd_setImageWithURL:[NSURL URLWithString:rightImgName] placeholderImage:[UIImage imageNamed:rightImgName]];
    
    self.pageControl.currentPage = _centerIndex;
}
- (void)jumpToAdvertDetail{
    if (self.advertClickBlock) {
        self.advertClickBlock(_centerIndex);
    }
}
#pragma mark -----NSTimer
- (void)startTimer{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
- (void)timerChanged{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.adScrollView scrollRectToVisible:CGRectMake(2 * CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) animated:NO];
    } completion:^(BOOL finished) {
        [self.adScrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) animated:NO];
        _centerIndex++;
        [self setSubviews];
    }];
}
- (void)stopTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark -----UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self startTimer];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX != CGRectGetWidth(self.bounds)) {
        [scrollView scrollRectToVisible:CGRectMake(CGRectGetWidth(self.bounds), 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) animated:NO];
        if (offsetX <= CGRectGetWidth(self.bounds)) {
            _centerIndex--;
        }else if (offsetX >= CGRectGetWidth(self.bounds) * 2){
            _centerIndex++;
        }
        [self setSubviews];
    }
}
@end
