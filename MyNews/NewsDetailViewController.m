//
//  NewsDetailViewController.m
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/14.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "ServerCommManager.h"
@interface NewsDetailViewController ()
@property (copy, nonatomic) NSDictionary *data;
@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* data = [NSString stringWithFormat:@"%@",self.data];
    [self loadData:data];
}


- (void)loadData:(NSString*) url {
    NSLog(@"[loadUrl] %@",url);
    [[ServerCommManager instance] getNewsDetail:url responseDelegate:self];
}

- (void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary *)dict{
    //NSLog(@"[getNewsDetail] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,dict);
    //TODO resolve data and show
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    
}

@end
