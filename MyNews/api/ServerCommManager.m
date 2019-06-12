//
//  ServerCommManager.h
//  MyNews
//  Singleton Pattern Object
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import "ServerCommManager.h"

@interface ServerCommManager()
@property NSString* serverRootURLStr;
@end

@implementation ServerCommManager

//use "instance" to get instance
+ (ServerCommManager *)instance {
    static ServerCommManager* instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self.class alloc] init];
        instance.serverRootURLStr = @"http://c.m.163.com/nc";
    });
    return instance;
}

- (NSMutableURLRequest*)wireRequestWithRelativeURL:(NSString*)urlStr httpMethod:(NSString*)method jsonBody:(NSString*)json {
    NSURL *url = [NSURL URLWithString:[_serverRootURLStr stringByAppendingString:urlStr]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    if(json!=nil || json.length > 0){
        request.HTTPBody = [json dataUsingEncoding:NSUTF8StringEncoding];
    }
    return request;
}

-(void)get20NewsHeadlineAtPage:(int) index responseDelegate:(id<ServerCommManagerDelegate>)delegate{
    if(index<1){
        index =1;
    }
    int start = (index-1)*10;
    int length = 20;
    NSString * relativeURLStr = [NSString stringWithFormat:@"/article/headline/T1348647853363/%d-%d.html",start,length];
    NSMutableURLRequest* request = [self wireRequestWithRelativeURL:relativeURLStr httpMethod:@"GET" jsonBody:nil];
    //init session
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error){
            return;
        }
        //resulve data using delegate
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *array;
        if(dict.count>0){
            array = [dict valueForKey:[dict allKeys][0]];
        }
        [delegate returnWithStatusCode:httpResponse.statusCode withArray:array];
        
    }];
    //run session task
    [dataTask resume];
}

@end
