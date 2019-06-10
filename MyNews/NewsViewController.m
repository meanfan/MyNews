//
//  NewsViewController.m
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "NewsViewController.h"
@interface NewsViewController ()

@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[ServerCommManager instance] get20NewsHeadlineAtPage:1 responseDelegate:self];
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    NSLog(@"[getNewsList] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,array);
}

- (void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary *)dict{
    
}

@end
