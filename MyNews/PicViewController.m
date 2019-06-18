//
//  PicViewController.m
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "PicViewController.h"
#import "WaterFlowLayout.h"
#import "UIImageView+WebCache.h"
#import "PicNewsViewCell.h"
#import "MJRefresh.h"
#define PIC_ARRAY_CAPACITY 100
@interface PicViewController ()<ServerCommManagerDelegate,UICollectionViewDataSource,WaterFlowLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview;


@property(strong,atomic) NSMutableArray *dataArray;
@property (assign,atomic) int currentLoadedPage;
@end

@implementation PicViewController



-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _currentLoadedPage=0;
    _dataArray=[NSMutableArray arrayWithCapacity:PIC_ARRAY_CAPACITY];
    WaterFlowLayout *layout=[[WaterFlowLayout alloc]init];
    layout.delegate=self;
    self.collectionview.collectionViewLayout = layout;
    self.collectionview.backgroundColor=[UIColor whiteColor];
    
    self.collectionview.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    self.collectionview.mj_footer=[MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreNews)];
    [self.collectionview.mj_header beginRefreshing];
    
}


-(void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    if(statusCode==200){
        for(NSDictionary *dict in array){
            [_dataArray addObject:dict];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.dataArray != nil || self.dataArray.count>0){
                [self.collectionview reloadData];
            }
        });
        
    }else{
        //failed
    }
    [self endRefresh];
    
}

- (void)refresh {
    self.currentLoadedPage = 0;
    [self getNextPicNewsAtPage:1];
}

- (void)loadMoreNews {
    self.currentLoadedPage+=1;
    [self getNextPicNewsAtPage:self.currentLoadedPage+1];
}

- (void) endRefresh {
    if(self.currentLoadedPage == 0){
        [self.collectionview.mj_header endRefreshing];
    }
    [self.collectionview.mj_footer endRefreshing];
}
- (void) getNextPicNewsAtPage:(int) page{
    if(page<1){
        page=1;
    }
    [[ServerCommManager instance] get20PicNewsAtPage:page responseDelegate:self];
}


-(void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary *)dict{
    
}


#pragma mark- load data
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PicNewsViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];

    NSDictionary *picDict=self.dataArray[indexPath.row];
    NSString *title=picDict[@"title"];
    NSURL *imageUrl = [NSURL URLWithString:picDict[@"mid_url"]];
    
    cell.title.text=title;
    [cell.pic sd_setImageWithURL:imageUrl placeholderImage:[UIImage imageNamed:@"default_pic.jpg"]];
    return cell;
}

-(CGFloat)waterFlowLayout:(WaterFlowLayout *)waterFlowLayout heightForItemAtIndexPath:(NSUInteger)indexPath itemWidth:(CGFloat)itemWidth{
    long width = [_dataArray[indexPath][@"mid_width"] longValue];
    long height = [_dataArray[indexPath][@"mid_height"] longValue];
    float ratio = height*1.0/width;
    return itemWidth*ratio;
}

- (NSUInteger)columnCountInWaterFlowLayout:(WaterFlowLayout *)waterFlowLayout{
    return 2;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




@end
