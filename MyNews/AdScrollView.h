//
//  AdScrollView.h
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/17.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AdScrollView : UIView
+ (instancetype)advertScrollViewFrame:(CGRect)frame imagesArray:(NSArray *)imagesArray timeInterval:(NSTimeInterval)timeInterval advertSelectBlock:(void(^)(int selectIndex))advertSelectBlock;
- (void)stopTimer;
@end

NS_ASSUME_NONNULL_END
