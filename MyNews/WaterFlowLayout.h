//
//  WaterFlowLayout.h
//  MyNews
//
//  Created by Apple6 on 19/6/17.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WaterFlowLayout;

@protocol WaterFlowLayoutDelegate <NSObject>

@required
/*
 * 每个item的高度
 */
- (CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth;

@optional
/**
 * 有多少列
 */
- (NSUInteger)columnCountInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

/**
 * 每列之间的间距
 */
- (CGFloat)columnMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

/**
 * 每行之间的间距
 */
- (CGFloat)rowMarginInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

/**
 * 每个item的内边距
 */
- (UIEdgeInsets)edgeInsetdInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout;

@end

@interface WaterFlowLayout : UICollectionViewLayout

@property(nonatomic,weak) id<WaterFlowLayoutDelegate> delegate;

@end
