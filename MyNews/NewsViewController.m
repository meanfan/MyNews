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
    self.newsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.newsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
    [self.newsTableView.mj_header beginRefreshing];
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    NSLog(@"[getNewsList] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,array);
    
    if(statusCode == 200){
        _currentLoadedPage++;

        //根据新闻优先级拼接更多
        long lastPriority = 0;
        if(_newsArray.count>0){
            NSDictionary* lastNews = [_newsArray lastObject];
            if([[lastNews allKeys] containsObject:@"priority"]){
                lastPriority = [[lastNews objectForKey:@"priority"] longValue];
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
                        lastPriority = 999;
                    }
                    if(array.count%20==1 && [array indexOfObject:dict]==0){ //如果获取到带头条的，会多一条
                        NSString *newsTname = dict[@"tname"];
                        if(newsTname!=nil && [newsTname compare:@"头条"]==0){ //确定是头条
                            _headNews = dict;
                        }
                    }else{
                        validNewsCount++;
                        [_newsArray addObject:dict];
                    }
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
    [self endRefresh];
}

- (void)refresh {
    self.currentLoadedPage = 0;
    [self getNextNewsHeadlineAtPage:1];
}

- (void)loadMoreNews {
    [self getNextNewsHeadlineAtPage:self.currentLoadedPage+1];
}

- (void) endRefresh {
    if(self.currentLoadedPage == 1){
        [self.newsTableView.mj_header endRefreshing];
    }
    [self.newsTableView.mj_footer endRefreshing];
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
    if(self.headNews!=nil){
        return _newsArray.count+1;
    }
    return _newsArray.count;
}

- (void) setImageViewSize:(UIImageView*)imageView byImage:(UIImage*) image{
    [imageView setImage:image];
    //根据获取的头条图片确定imageview尺寸
    CGSize imageSize = [image size];
    float imageRatio = imageSize.width / imageSize.height;
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGSize itemSize = CGSizeMake(screenWidth, screenWidth/imageRatio);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [imageView.image drawInRect:imageRect];
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row==0 && self.headNews!=nil){
        HeadNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_head" forIndexPath:indexPath];
        NSString *title = self.headNews[@"title"];
        UIImage *image;
        NSURL *imageUrl = [NSURL URLWithString:self.headNews[@"imgsrc"]];
        if(imageUrl!=nil){
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: imageUrl];
            image = [UIImage imageWithData:imageData];
            
        }else{
            image = [UIImage imageNamed:@"default_pic.jpg"];
        }
        [self setImageViewSize:cell.newsImageView byImage:image];
        cell.newsTitleLabel.text = title;
        return cell;
    }
    
    if(self.newsArray == nil){
        return nil;
    }
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell_normal" forIndexPath:indexPath];
    NSDictionary* newsDict = self.newsArray[indexPath.row];
    NSString *title = newsDict[@"title"];
    NSString *source = newsDict[@"source"];
    //NSString *replyCount = newsDict[@"replyCount"];
    cell.newsTitleTextView.text = title;
    cell.newsSrcTextView.text = source;
    [self setImageViewSize:cell.newsImageView byImage:[UIImage imageNamed:@"default_pic.jpg"]];
    
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

@end
