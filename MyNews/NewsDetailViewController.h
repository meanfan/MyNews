//
//  NewsDetailViewController.h
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/14.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommManagerDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface NewsDetailViewController : UIViewController <ServerCommManagerDelegate>
-(void)setUrl:(NSString *)url image:(UIImage*) image;
@end

NS_ASSUME_NONNULL_END
