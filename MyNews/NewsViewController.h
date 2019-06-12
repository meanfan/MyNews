//
//  FirstViewController.h
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerCommManager.h"
#import "ServerCommManagerDelegate.h"
#import "NewsTableViewCell.h"
@interface NewsViewController : UIViewController<ServerCommManagerDelegate,UITableViewDelegate,UITableViewDataSource>


@end

