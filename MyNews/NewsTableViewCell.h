//
//  NewsTableViewCell.h
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/12.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *newsImageView;
@property (weak, nonatomic) IBOutlet UITextView *newsTitleTextView;
@property (weak, nonatomic) IBOutlet UITextView *newsSrcTextView;


@end

NS_ASSUME_NONNULL_END
