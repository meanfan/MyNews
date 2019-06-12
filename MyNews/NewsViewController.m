//
//  NewsViewController.m
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "NewsViewController.h"
#import "MJRefresh.h"
#define NEWS_ARRAY_CAPACITY 100
@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (strong,atomic) NSMutableArray* newsArray;
@property (strong,atomic) NSDictionary* headNews;
@property (assign,atomic) int currentLoadedPage;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _newsArray = [NSMutableArray arrayWithCapacity:NEWS_ARRAY_CAPACITY];
    _currentLoadedPage = 0;
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentLoadedPage = 0;
        [self getNextNewsHeadlineAtPage:1];
    }];
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreNews];
    }];
    [self.newsTableView.mj_header beginRefreshing];
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    NSLog(@"[getNewsList] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,array);
    
    if(statusCode == 200){
        _currentLoadedPage++;
        if(array.count%20==1){ //如果获取到带头条的，会多一条
            _headNews = array[0];
        }
        //根据新闻优先级拼接更多
        long lastPriority = 0;
        if(_newsArray.count>0){
            int lastPriority;
            NSDictionary* lastNews = [_newsArray lastObject];
            if([[lastNews allKeys] containsObject:@"priority"]){
                lastPriority = [[lastNews objectForKey:@"priority"] intValue];
            }else{
                lastPriority = 999;
                NSLog(@"get LastPriority failed");
            }
        }else{
            lastPriority = 999;
        }
        int validNewsCount = 0;
        for(NSDictionary* dict in array){
            if(dict[@"priority"]!=nil){
                if([dict[@"priority"] intValue] < lastPriority){
                    if(_newsArray.count==NEWS_ARRAY_CAPACITY){ // 可能需要再特殊处理
                        [_newsArray removeAllObjects];
                    }
                    validNewsCount++;
                    [_newsArray addObject:dict];
                }else if([dict[@"priority"] intValue]==lastPriority){
                    //TODO proirity相同的处理，暂时先舍弃
                }
            }
        }
        if(validNewsCount==0){
            //TODO 没有获取到有效新闻的处理
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.newsArray != nil || self.newsArray.count>0){
                [self.newsTableView reloadData];
            }
        });
    }else{
        //TODO 获取失败
    }
    [self.newsTableView.mj_header endRefreshing];
}

- (void)loadMoreNews {
    [self getNextNewsHeadlineAtPage:self.currentLoadedPage+1];
}

- (void) getNextNewsHeadlineAtPage:(int) page{
    if(page<1){
        page=1;
    }
    [[ServerCommManager instance] get20NewsHeadlineAtPage:page responseDelegate:self];
}

- (void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary *)dict{
    
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _newsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_normal" forIndexPath:indexPath];
    if(self.newsArray == nil){
        return cell;
    }
    NSDictionary* newsDict = self.newsArray[indexPath.row];
    NSString *title = newsDict[@"title"];
    NSString *source = newsDict[@"source"];
    //NSString *replyCount = newsDict[@"replyCount"];
    cell.newsTitleTextView.text = title;
    cell.newsSrcTextView.text = source;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
