//
//  ServerCommManager.h
//  MyNews
//  Singleton Pattern Object
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerCommManagerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface ServerCommManager : NSObject<NSURLSessionDataDelegate>
+ (ServerCommManager *)instance;
- (NSString*)serverRootURLStr;
-(void)get20NewsHeadlineAtPage:(int) index responseDelegate:(id<ServerCommManagerDelegate>)delegate;
-(void)getNewsDetail:(NSString*) url responseDelegate:(id<ServerCommManagerDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
