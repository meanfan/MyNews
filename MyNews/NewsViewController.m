//
//  NewsViewController.m
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "NewsViewController.h"
#define NEWS_ARRAY_CAPACITY 100
@interface NewsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
@property (strong,nonatomic) NSMutableArray* newsArray;
@property (strong,nonatomic) NSDictionary* headNews;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.newsArray=[NSMutableArray arrayWithCapacity:NEWS_ARRAY_CAPACITY];
    [[ServerCommManager instance] get20NewsHeadlineAtPage:1 responseDelegate:self];
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    //NSLog(@"[getNewsList] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,array);

    if(statusCode == 200){
        if(array.count%20==1){ //如果获取到带头条的，会多一条
            _headNews = array[0];
        }
        int intLastPriority = 0;
        if(_newsArray.count>0){
            NSString *strLastPriority =[_newsArray lastObject][@"priority"];
            if(strLastPriority!=nil && strLastPriority.length>0){
                intLastPriority = [strLastPriority intValue];
            }else{
                intLastPriority = 999;
                NSLog(@"get LastPriority failed");
            }
        }else{
            intLastPriority = 999;
        }
        int validNewsCount = 0;
        for(NSDictionary* dict in array){
            if(dict[@"priority"]!=nil){
                if([dict[@"priority"] intValue] < intLastPriority){
                    if(_newsArray.count==NEWS_ARRAY_CAPACITY){ // 可能需要再特殊处理
                        [_newsArray removeAllObjects];
                    }
                    validNewsCount++;
                    [_newsArray addObject:dict];
                }else if([dict[@"priority"] intValue]==intLastPriority){
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
