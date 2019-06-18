//
//  PicNewsVieCell.h
//  MyNews
//
//  Created by Apple6 on 19/6/17.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import<UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicNewsViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pic;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end

NS_ASSUME_NONNULL_END
