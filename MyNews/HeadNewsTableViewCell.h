//
//  HeadNewsTableViewCell.h
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/13.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HeadNewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UILabel *newsTitleLabel;

@end

NS_ASSUME_NONNULL_END
