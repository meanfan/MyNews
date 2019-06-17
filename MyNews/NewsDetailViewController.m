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
@property (strong, nonatomic) NSString *newsFullUrl;
@property (strong, nonatomic) UIImage *newsImage;

@property (weak, nonatomic) IBOutlet UITextView *newsTextView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

-(void)setUrl:(NSString *)url image:(UIImage*) image{
    _newsFullUrl = [url copy];
    _newsImage = [image copy];
}

- (void)loadData {
    NSLog(@"[loadUrl] %@",_newsFullUrl);
    [[ServerCommManager instance] getNewsDetail:_newsFullUrl responseDelegate:self];
}

- (void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary *)dict{
    //NSLog(@"[getNewsDetail] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,dict);
    if(statusCode != 200){
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *errorStr = [NSString stringWithFormat:@"加载失败，code:%ld",statusCode];
            self.newsTextView.attributedText = [[NSMutableAttributedString alloc]initWithString:errorStr];
        });
        return;
    }
    NSString *lineBreak = @"\n";
    //创建标题 富文本
    NSString *title = dict[@"title"];
    NSMutableAttributedString * attributedTotal = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange titleRange = NSMakeRange(0, attributedTotal.string.length);
    [attributedTotal addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:titleRange];// 设置字体大小
    NSMutableParagraphStyle *titleParaStyle = [[NSMutableParagraphStyle alloc]init];
    titleParaStyle.lineSpacing = 10;
    [attributedTotal addAttribute:NSParagraphStyleAttributeName value:titleParaStyle range:titleRange]; //设置段落属性
    
    //创建时间 富文本
    NSString *time = [[lineBreak stringByAppendingString:dict[@"ptime"]] stringByAppendingString:lineBreak]; //前后加入换行符
    NSMutableAttributedString * attributedTime = [[NSMutableAttributedString alloc]initWithString:time];
    NSRange timeRange = NSMakeRange(0, attributedTime.string.length);
    [attributedTime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:timeRange];// 设置字体大小
    NSMutableParagraphStyle *timeParaStyle = [[NSMutableParagraphStyle alloc]init];
    timeParaStyle.lineSpacing = 5;
    [attributedTime addAttribute:NSParagraphStyleAttributeName value:timeParaStyle range:timeRange]; //设置段落属性
    [attributedTotal appendAttributedString:attributedTime];
    
    if(_newsImage){
        //海报 富文本
        NSTextAttachment *attachment = [[NSTextAttachment alloc]init];
        attachment.image = _newsImage;
        //根据获取的图片确定尺寸
        CGSize imageSize = [_newsImage size];
        float imageRatio = imageSize.width / imageSize.height;
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        CGSize itemSize = CGSizeMake(screenWidth, screenWidth/imageRatio);
        UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
        CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
        attachment.bounds = imageRect;
        NSAttributedString * attributedPic = [NSAttributedString attributedStringWithAttachment:attachment];
        [attributedTotal appendAttributedString:attributedPic];
        [attributedTotal appendAttributedString:[[NSMutableAttributedString alloc]initWithString:lineBreak]];
    }
    //创建正文 富文本
    NSString *contextHtml = dict[@"body"];
    NSData *data = [contextHtml dataUsingEncoding:NSUnicodeStringEncoding];
    NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSMutableAttributedString *attributedContext = [[NSMutableAttributedString alloc]initWithData:data options:options documentAttributes:nil error:nil];
    NSRange contextRange = NSMakeRange(0, attributedContext.string.length);
    [attributedContext addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:contextRange];// 设置字体大小
    NSMutableParagraphStyle *contextParaStyle = [[NSMutableParagraphStyle alloc]init];
    contextParaStyle.lineSpacing = 6;
    [attributedContext addAttribute:NSParagraphStyleAttributeName value:contextParaStyle range:contextRange]; //设置段落属性
    [attributedTotal appendAttributedString:attributedContext];
    
    //相关内容
    NSArray *relatives = dict[@"relative_sys"];
    if(relatives && relatives.count>0){
        NSMutableAttributedString * attributedRelativeNewsTip = [[NSMutableAttributedString alloc]initWithString:@"相关内容\n"];
        [attributedTotal appendAttributedString:attributedRelativeNewsTip];
    }
    for(NSDictionary * relativeNews in relatives){
        NSString *title = [relativeNews[@"title"] stringByAppendingString:lineBreak];
        //NSString *imgSrc =relativeNews[@"imgsrc"];
        NSMutableAttributedString * attributedRelativeNews = [[NSMutableAttributedString alloc]initWithString:title];
        NSRange titleRange = NSMakeRange(0, attributedRelativeNews.string.length);
        [attributedRelativeNews addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:titleRange];// 设置字体大小
        NSMutableParagraphStyle *relativeNewsParaStyle = [[NSMutableParagraphStyle alloc]init];
        relativeNewsParaStyle.lineSpacing = 5;
        [attributedRelativeNews addAttribute:NSParagraphStyleAttributeName value:relativeNewsParaStyle range:titleRange]; //设置段落属性/Users/MeanFan/Desktop/MyNews/MyNews/HeadNewsTableViewCell.m
        [attributedRelativeNews addAttribute:NSLinkAttributeName value:relativeNews[@"docID"] range:titleRange];
        [attributedTotal appendAttributedString:attributedRelativeNews];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.newsTextView.attributedText = attributedTotal;
        self.newsTextView.linkTextAttributes = @{NSForegroundColorAttributeName: [UIColor blueColor],
                                         NSUnderlineColorAttributeName: [UIColor lightGrayColor],
                                         NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
        
    });
    
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    return YES;
}
@end
