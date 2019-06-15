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
@property (strong, nonatomic) NSString *data;
@property (weak, nonatomic) IBOutlet UITextView *newsTextView;

@end

@implementation NewsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString* data = [NSString stringWithFormat:@"%@",self.data];
    [self loadData:data];
}

-(void)setData:(NSString *)data{
    _data = data;
}

- (void)loadData:(NSString*) url {
    NSLog(@"[loadUrl] %@",url);
    [[ServerCommManager instance] getNewsDetail:url responseDelegate:self];
}

- (void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary *)dict{
    //NSLog(@"[getNewsDetail] responseStatusCode:%ld\ndata:\n %@\n--------------",statusCode,dict);
    NSString *lineBreak = @"\n";
    //创建标题 富文本
    NSString *title = dict[@"title"];
    NSMutableAttributedString * attributedTitle = [[NSMutableAttributedString alloc]initWithString:title];
    NSRange titleRange = NSMakeRange(0, attributedTitle.string.length);
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:titleRange];// 设置字体大小
    NSMutableParagraphStyle *titleParaStyle = [[NSMutableParagraphStyle alloc]init];
    titleParaStyle.lineSpacing = 10;
    [attributedTitle addAttribute:NSParagraphStyleAttributeName value:titleParaStyle range:titleRange]; //设置段落属性
    
    //创建时间 富文本
    NSString *time = [[lineBreak stringByAppendingString:dict[@"ptime"]] stringByAppendingString:lineBreak]; //前后加入换行符
    NSMutableAttributedString * attributedTime = [[NSMutableAttributedString alloc]initWithString:time];
    NSRange timeRange = NSMakeRange(0, attributedTime.string.length);
    [attributedTime addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:timeRange];// 设置字体大小
    NSMutableParagraphStyle *timeParaStyle = [[NSMutableParagraphStyle alloc]init];
    timeParaStyle.lineSpacing = 5;
    [attributedTime addAttribute:NSParagraphStyleAttributeName value:timeParaStyle range:timeRange]; //设置段落属性
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
    
    //拼接
    [attributedTitle appendAttributedString:attributedTime];
    [attributedTitle appendAttributedString:attributedContext];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.newsTextView.attributedText = attributedTitle;
    });
    
}

- (void)returnWithStatusCode:(long)statusCode withArray:(NSArray *)array{
    
}

@end
