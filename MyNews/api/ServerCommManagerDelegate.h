//
//  ServerCommManagerDelegate.h
//  MyNews
//
//  Created by MeanFan Moo on 2019/6/10.
//  Copyright © 2019年 MeanFan Moo. All rights reserved.
//

#ifndef ServerCommManagerDelegate_h
#define ServerCommManagerDelegate_h

@protocol ServerCommManagerDelegate <NSObject>

-(void)returnWithStatusCode:(long)statusCode withDict:(NSDictionary*)dict;

-(void)returnWithStatusCode:(long)statusCode withArray:(NSArray*)array;

@end

#endif /* ServerCommManagerDelegate_h */
